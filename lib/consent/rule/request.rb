require 'forwardable'

module Consent
  class Rule
    class Request
      
      extend Forwardable
      def_delegators(:@expression, :add_observer, :===, :inspect)
      
      def initialize(expression)
        @expression = expression
        flush_throttles!
      end
      
      def throttle!(key, rate)
        throttle = (@throttles[key.to_s] ||= Throttle.new)
        throttle.rate = rate
        throttle
      end
      
      def flush_throttles!
        @throttles = {}
      end
      
    end
  end
end

