module Consent
  module Extensions
    module Integer
      
      %w(second minute hour day month).each do |interval|
        module_eval do
          define_method("per_#{ interval }") do
            Rate.new(self, 1.__send__(interval))
          end
        end
      end
      
      def per(interval)
        Rate.new(self, interval)
      end
      
    end
  end
  
  class Rate
    attr_reader :limit, :interval
    
    def initialize(limit, interval)
      @limit, @interval = limit, interval
    end
  end
end

