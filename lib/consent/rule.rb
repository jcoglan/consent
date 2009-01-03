module Consent
  class Rule
    
    def initialize(expression, block)
      @expression, @predicate = expression, block
      expression.block = block
    end
    
    def check(context)
      applies?(context) ? context.instance_eval(&@predicate) : true
    end
    
  private
    
    def applies?(context)
      @expression === context
    end
    
  end
end

