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

def short_hash r
  h = {}
  h[:date] = r[:date]
  h[:high] = r[:high]
  h[:low] = r[:low]
  h[:close] = r[:close]
  h[:volume] = r[:volume]
  h
end

def get_data_100 ticker
  YahooFinance::get_historical_quotes_days(ticker, 100)
end

puts 'Retrieving historical data'
cba = get_data_100("CBA.AX").inject([]) { |lst, q| lst << bar_to_hash(q) }
nab = get_data_100("NAB.AX").inject([]) { |lst, q| lst << bar_to_hash(q) }
nab_no_open = nab.inject([]) { |lst, q| lst << short_hash(q) }

sma = Indicator.create_named :sma_13
sma_results = sma.run(Indicator::DataMapper::Map.new(cba, :open))

ema = Indicator.create_named :ema_25
ema.default_getter = :high
ema_results = sma.run cba

sub = Indicator.create :sub
sub.default_getter = :low
sub_results = sub.run cba, nab

stoch = Indicator.create :stoch
stoch_results = stoch.run nab
stoch_results = stoch.run nab_no_open

adx = Indicator.create :adx
adx_results = adx.run(
  new_map(nab, :open), 
  new_map(nab, :high), 
  new_map(nab, :low), 
  new_map(nab, :close))

# Or the default mapping 
adx_results = adx.run nab
