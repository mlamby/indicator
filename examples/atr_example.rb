# This sample requires the yahoo finance gem
require 'yahoofinance'
require 'indicator'

def bar_to_hash r
  h = {}
  h[:date] = Date.parse(r[0])
  h[:open] = r[1].to_f
  h[:high] = r[2].to_f
  h[:low] = r[3].to_f
  h[:close] = r[4].to_f
  h[:volume] = r[5].to_f
  h
end

yahoo_cba = YahooFinance::get_historical_quotes_days("CBA.AX", 30)
yahoo_nab = YahooFinance::get_historical_quotes_days("NAB.AX", 30)

puts "Downloading Data"
cba = yahoo_cba.inject([]) { |lst, q| lst << bar_to_hash(q) }
nab = yahoo_nab.inject([]) { |lst, q| lst << bar_to_hash(q) }

# First way to use ATR - Use the factory
# Create an ATR indicator with the time_period argument set to 14
atr = Indicator.create_named :atr_14
# Run the ATR using the stock prices for CBA and NAB
result = atr.run(cba)
puts "14 Day ATR For CBA.AX"
puts result.join(',')

result = atr.run(nab)
puts "14 Day ATR For NAB.AX"
puts result.join(',')

# Second way to use ATR - Manually create the indicator class
atr = Indicator::AutoGen::Atr.new()
# Configure Arguments
atr.time_period = 7

# Run the ATR using the stock prices for CBA and NAB
result = atr.run(cba)
puts "7 Day ATR For CBA.AX"
puts result.join(',')

result = atr.run(nab)
puts "7 Day ATR For NAB.AX"
puts result.join(',')
