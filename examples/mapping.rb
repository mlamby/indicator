# This sample requires the yahoo finance gem
require 'yahoofinance'
require 'indicator'

include Indicator
include Indicator::AutoGen

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

def get_data_100 ticker
  YahooFinance::get_historical_quotes_days(ticker, 100)
end

puts 'Retrieving historical data'
cba = get_data_100("CBA.AX").inject([]) { |lst, q| lst << bar_to_hash(q) }
nab = get_data_100("NAB.AX").inject([]) { |lst, q| lst << bar_to_hash(q) }

sma = Sma.new(13)
sma_results = sma.run(DataMapper::Map.new(cba, :open))

ema = Ema.new(25)
ema.default_getter = :high
ema_results = sma.run cba

sub = Sub.new
sub.default_getter = :low
sub_results = sub.run cba, nab

adx = Adx.new
adx_results = adx.run(
  new_map(nab, :open), 
  new_map(nab, :high), 
  new_map(nab, :low), 
  new_map(nab, :close))

# Or the default mapping 
adx_results = adx.run nab
