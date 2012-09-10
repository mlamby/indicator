require 'talib_ruby'
require 'indicator/data_mapper'
require 'indicator/base'
require 'indicator/auto_gen'

module Indicator
  
  class UnknownIndicator < StandardError
  end
  
  def self.contains? name
    not Indicator.get(name).nil? 
  end

  def self.get name
    name = name.to_s
    Base.indicators.find do |klass|
      klass_name = klass.name.split('::')[-1]
      klass_name.casecmp(name) == 0
    end
  end

  def self.create type, *args
    klass = Indicator.get type
    raise UnknownIndicator,type if klass.nil?

    klass.send(:new, *args)  
  end

  def self.create_named name, *args
    sp = name.to_s.split "_"

    type = sp.first.to_sym

    args = sp.drop(1).collect { |a| a.to_i } if args.empty?

    obj = Indicator.create type, *args 
    obj.name = name
    obj
  end

  def self.list
    Indicator::Base.indicators
  end

  def self.info type
    klass = Indicator.get type
    raise UnknownIndicator,type if klass.nil?
    """Indicator: #{klass.name}
  Arguments: #{klass.arguments}  
  Input Count: #{klass.inputs.count}
  Inputs: #{klass.inputs}
  Output Count: #{klass.outputs.count}
  Outputs: #{klass.outputs}"""
  end
end
