# Ta-Lib function mapping class 
# Function: 'CDLABANDONEDBABY'
# Description: 'Abandoned Baby'
# This file has been autogenerated - Do Not Edit.
class Indicator::AutoGen::CdlAbandonedBaby < Indicator::Base
  # Penetration <Double>
  attr_accessor :penetration

  def initialize(*args)
    if args.first.is_a? Hash
      h = args.first
      @penetration = h[:penetration] || 3.000000e-1
    else
      @penetration = args[0] || 3.000000e-1 
    end
    
    @func = TaLib::Function.new("CDLABANDONEDBABY")
  end

  # Is price data required as an input
  def self.price_input?
    true
  end

  # The list of arguments
  def self.arguments
    [ :penetration ]
  end

  # The minimum set of inputs required
  def self.inputs
    [ :open, :high, :low, :close ]
  end

  # The outputs generated by this function
  def self.outputs
    [ :out_integer ]
  end

  def run(*args)
    o, h, l, c, v, len = map_ohlcv(self.class.inputs, *args)
    @func.in_price(0, o, h, l, c, v, nil)

    @func.opt_real(0, @penetration)

    out_integer = Array.new(len)
    @func.out_int(0, out_integer)
  
    @func.call(0, len - 1)

    out_integer
  end
end
