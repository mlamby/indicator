# Ta-Lib function mapping class 
# Function: 'MOM'
# Description: 'Momentum'
# This file has been autogenerated - Do Not Edit.
class Indicator::AutoGen::Mom < Indicator::Base
  # Time Period <Integer>
  attr_accessor :time_period

  def initialize(*args)
    if args.first.is_a? Hash
      h = args.first
      @time_period = h[:time_period] || 10
    else
      @time_period = args[0] || 10 
    end
    
    @func = TaLib::Function.new("MOM")
  end

  # Is price data required as an input
  def self.price_input?
    false
  end

  # The list of arguments
  def self.arguments
    [ :time_period ]
  end

  # The minimum set of inputs required
  def self.inputs
    [ :in_real ]
  end

  # The outputs generated by this function
  def self.outputs
    [ :out_real ]
  end

  def run(in_real)
    len = map(in_real).length
    @func.in_real(0, map(in_real))

    @func.opt_int(0, @time_period)

    out_real = Array.new(len)
    @func.out_real(0, out_real)
  
    @func.call(0, len - 1)

    out_real
  end
end
