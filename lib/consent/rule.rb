require 'forwardable'

module Consent
  class Rule
    
    extend Forwardable
    def_delegators(:@request, :flush_throttles!)
    
    def initialize(expression, block)
      @request, @predicate = Request.new(expression), block
      @request.add_observer(self)
    end
    
    def update(message)
      @invalid = true if message == :destroyed
    end
    
    def check(context)
      return true unless applies?(context)
      result = begin
        context.instance_eval(&@predicate) != false
      rescue DenyException
        false
      rescue AllowException
        true
      rescue RedirectException => re
        {:redirect => re.params}
      end
      
      @throttles = context.throttles.map do |key, rate|
        throttle = @request.throttle!(key, rate)
        result = false if @request.over_capacity?(key)
        throttle
      end
      
      result
    end
    
    def ping!(context)
      return if @throttles.nil? or !applies?(context)
      @throttles.each { |thr| thr.ping! }
    end
    
    def line_number
      @predicate.inspect.scan(/@.*>/).first[1...-1]
    end
    
    def inspect
      source = @request.inspect
      source << '#invalid' if @invalid
      source
    end
    
  private
    
    def applies?(context)
      !@invalid and @request === context
    end
    
  end
end

