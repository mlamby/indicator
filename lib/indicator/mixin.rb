require 'indicator'

module Indicator
  module Mixin
    def indicator type, *args
      i = Indicator.create_named type, *args
      i.run self
    end
  end
end

# Extend the array class with the mixin
class Array
  include Indicator::Mixin
end
