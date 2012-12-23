module Indicator
 
  # Base Indicator 
  class Base
    include Indicator::DataMapper

    attr_accessor :name

    class << self
      attr_reader :indicators
    end

    @indicators = []
      
    def self.inherited(subclass)
      Base.indicators << subclass
    end

    def map_ohlcv types, *args

      raise ArgumentError unless args.length > 0
      first = args.first

      l = [:open, :high, :low, :close, :volume].inject([]) do |lst, t|
        if types.include? t
          a = args.shift
          lst << (a ? map(a, t) : map(first, t))
        else
          lst << nil
        end
      end

      # Push the length onto the end of the array
      l << first.length
    end
  end
end
