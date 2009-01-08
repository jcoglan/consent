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
      
      def ping!(key)
        throttle = throttle_for(key)
        throttle.ping! if throttle
      end
      
      def over_capacity?(key)
        throttle = throttle_for(key)
        throttle && throttle.over_capacity?
      end
      
      def flush_throttles!
        @throttles = {}
      end
      
    private
      
      def throttle_for(key)
        @throttles[key.to_s]
      end
      
    end
  end
end

