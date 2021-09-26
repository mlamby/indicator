# Ta-Lib function mapping class 
# Function: 'SAREXT'
# Description: 'Parabolic SAR - Extended'
# This file has been autogenerated - Do Not Edit.
class Indicator::AutoGen::SarExt < Indicator::Base
  # Start Value <Double>
  attr_accessor :start_value
  # Offset on Reverse <Double>
  attr_accessor :offset_on_reverse
  # AF Init Long <Double>
  attr_accessor :af_init_long
  # AF Long <Double>
  attr_accessor :af_long
  # AF Max Long <Double>
  attr_accessor :af_max_long
  # AF Init Short <Double>
  attr_accessor :af_init_short
  # AF Short <Double>
  attr_accessor :af_short
  # AF Max Short <Double>
  attr_accessor :af_max_short

  def initialize(*args)
    if args.first.is_a? Hash
      h = args.first
      @start_value = h[:start_value] || 0.000000e+0
      @offset_on_reverse = h[:offset_on_reverse] || 0.000000e+0
      @af_init_long = h[:af_init_long] || 2.000000e-2
      @af_long = h[:af_long] || 2.000000e-2
      @af_max_long = h[:af_max_long] || 2.000000e-1
      @af_init_short = h[:af_init_short] || 2.000000e-2
      @af_short = h[:af_short] || 2.000000e-2
      @af_max_short = h[:af_max_short] || 2.000000e-1
    else
      @start_value = args[0] || 0.000000e+0 
      @offset_on_reverse = args[1] || 0.000000e+0 
      @af_init_long = args[2] || 2.000000e-2 
      @af_long = args[3] || 2.000000e-2 
      @af_max_long = args[4] || 2.000000e-1 
      @af_init_short = args[5] || 2.000000e-2 
      @af_short = args[6] || 2.000000e-2 
      @af_max_short = args[7] || 2.000000e-1 
    end
    
    @func = TaLib::Function.new("SAREXT")
  end

  # Is price data required as an input
  def self.price_input?
    true
  end

  # The list of arguments
  def self.arguments
    [ :start_value, :offset_on_reverse, :af_init_long, :af_long, :af_max_long, :af_init_short, :af_short, :af_max_short ]
  end

  # The minimum set of inputs required
  def self.inputs
    [ :high, :low ]
  end

  # The outputs generated by this function
  def self.outputs
    [ :out_real ]
  end

  def run(*args)
    o, h, l, c, v, len = map_ohlcv(self.class.inputs, *args)
    @func.in_price(0, o, h, l, c, v, nil)

    @func.opt_real(0, @start_value)
    @func.opt_real(1, @offset_on_reverse)
    @func.opt_real(2, @af_init_long)
    @func.opt_real(3, @af_long)
    @func.opt_real(4, @af_max_long)
    @func.opt_real(5, @af_init_short)
    @func.opt_real(6, @af_short)
    @func.opt_real(7, @af_max_short)

    out_real = Array.new(len)
    @func.out_real(0, out_real)
  
    @func.call(0, len - 1)

    out_real
  end
end
