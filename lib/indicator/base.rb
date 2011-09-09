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
  end
end
