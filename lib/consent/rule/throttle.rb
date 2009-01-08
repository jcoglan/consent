module Consent
  class Rule
    class Throttle
      
      def initialize(rate = nil)
        @rate, @times = rate, []
      end
      
      def rate=(rate)
        rate = Rate.new(1, rate) if Numeric === rate
        @rate = rate
      end
      
      def ping!
        @times << Time.now
      end
      
      def over_capacity?
        flush!
        @times.size >= @rate.limit
      end
      
      def flush!
        cutoff = @rate.interval.ago
        @times.delete_if { |time| time < cutoff }
      end
      
    end
  end
end

