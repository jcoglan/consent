require 'forwardable'

module Consent
  class Rule
    
    extend Forwardable
    def_delegator(:@expression, :inspect)
    
    def initialize(expression, block)
      @expression, @predicate = expression, block
      @expression.add_observer(self)
    end
    
    def line_number
      @predicate.inspect.scan(/@.*>/).first[1...-1]
    end
    
    def check(context)
      return true unless applies?(context)
      context.instance_eval(&@predicate) != false
    rescue DenyException
      false
    rescue AllowException
      true
    rescue RedirectException => re
      re.params
    end
    
    def update(message)
      @invalid = true if message == :destroyed
    end
    
  private
    
    def applies?(context)
      !@invalid and @expression === context
    end
    
  end
end

