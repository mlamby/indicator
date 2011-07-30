require 'minitest/autorun'
require 'ta_indicator'

class DataMapperTest < MiniTest::Unit::TestCase
  class Bar
    attr_accessor :open, :high, :low, :close, :volume

    def initialize seed
      @open = seed
      @high = seed + 1
      @low = seed + 2
      @close = seed + 3
      @volume = seed + 4
    end

    def [] index
      if index == :mid
        return (@open + @close) / 2.0
      elsif index == :offset
        return @open + 100
      end
    end

    def to_s
      "#{@open},#{@high},#{@low},#{@close},#{@volume}"
    end
  end

  class MapTest
    include DataMapper
  end
  
  def setup
    @mapper = MapTest.new
    @default_getter = :open
    @simple_ds = [1,2,3,4,5,6,7,8,9,10]
    @simple_ds2 = [11,12,13,14,15,16,17,18,19,20]

    @bars = (1..10).inject([]) { |list, i| list << Bar.new(i) }
  end

  def test_simple
    r = @mapper.map @simple_ds, @default_getter

    assert_equal @simple_ds, r
  end

  def ensure_default_is_not_used
    r = @mapper.map @simple_ds, lambda { |i| i * 10 }
    assert_equal @simple_ds, r
  end

  def test_with_lamda
    m = DataMapper::Map.new @simple_ds, lambda { |i| i * 10 }
    r = @mapper.map m, @default_getter
   
    ds2 = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100] 
    assert_equal ds2, r 
  end

  def test_double_with_symbol_map
    m = DataMapper::Map.new @bars, :open
    r = @mapper.map m, @default_getter

    assert_equal [1,2,3,4,5,6,7,8,9,10], r
  end
  
  def test_double_with_hash_map
    m = DataMapper::Map.new @bars, :mid
    r = @mapper.map m, @default_getter

    assert_equal [2.5,3.5,4.5,5.5,6.5,7.5,8.5,9.5,10.5,11.5], r
  end
end
