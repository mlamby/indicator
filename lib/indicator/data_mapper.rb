module Indicator
  module DataMapper

    class SourceMustBeEnumerable < StandardError
    end

    class InvalidMapping < StandardError
    end

    Map = Struct.new(:source, :getter)

    def default_getter
      @default_getter || :close
    end

    def default_getter= v
      @default_getter = v
    end

    def map ds, getter=default_getter

      return nil unless ds

      # ds can be supplied as an array of [source, mapping] or simply
      # the source
      if ds.is_a? Map
        source = ds.source
        mapping = ds.getter
      else
        source = ds
      end

      raise SourceMustBeEnumerable unless source.is_a? Enumerable
      raise ArgumentError unless getter

      # Return nil straight away if the data source is empty. The
      # downstream ta-lib functions can handle a nil argument.
      return nil unless source.length > 0

      # No need to go any further if no mapping was specified and
      # the specified data source responds to 'to_f'.
      element = source.first
      return source if element.respond_to?(:to_f) and mapping.nil?

      mapping ||= getter
      mapping_sym = mapping.to_sym rescue nil

      # Figure out how to use the mapping value.
      # It can either be a directly callable mapping, a function name
      # or a hash index.
      map_proc =
        if mapping.respond_to? :call
          mapping
        else
          if not mapping_sym.nil? and element.respond_to?(mapping_sym)
            mapping_sym.to_proc
          elsif element.respond_to?(:[])
            ->(e) { e[mapping] }
          end
        end

      raise InvalidMapping unless map_proc

      # Returned the mapped data
      source.collect { |e| map_proc.call(e) }
    end

  end
end

def new_map(ds, map)
  Indicator::DataMapper::Map.new(ds, map)
end
