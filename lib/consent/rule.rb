module Consent
  class Rule
    
    def initialize(expression, block)
      @expression, @predicate = expression, block
      @expression.add_observer(self)
      flush_throttles!
    end
    
    def update(message)
      @invalid = true if message == :destroyed
    end
    
    def flush_throttles!
      @throttles.each { |key, thr| thr.flush! } if @throttles
      @throttles = {}
    end
    
    def throttle!(key, rate)
      throttle = (@throttles[key.to_s] ||= Throttle.new)
      throttle.rate = rate
      throttle
    end
    
    def check(context)
      return true unless applies?(context)
      context.clear_throttles!
      
      result = begin
        context.instance_eval(&@predicate) != false
      rescue DenyException
        false
      rescue AllowException
        true
      rescue RedirectException => re
        {:redirect => re.params}
      end
      
      context.throttles.each do |key, rate|
        throttle = throttle!(key, rate)
        result = false if throttle.over_capacity?
      end
      
      result
    end
    
    def ping!(context)
      return if @throttles.nil? or !applies?(context)
      @throttles.each { |key, thr| thr.ping! }
    end
    
    def line_number
      @predicate.inspect.scan(/@.*>/).first[1...-1]
    end
    
    def inspect
      source = @expression.inspect
      source << '#invalid' if @invalid
      source
    end
    
  private
    
    def applies?(context)
      !@invalid and @expression === context
    end
    
  end
end

