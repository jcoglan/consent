module Consent
  class Rule
    
    def self.push(list, exprs, block)
      exprs.block = block
      exprs = [exprs] unless Enumerable === exprs
      exprs.each { |expr| list << self.new(expr, block) }
    end
    
    def initialize(expression, block)
      @expression, @predicate = expression, block
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
    
  private
    
    def applies?(context)
      @expression === context
    end
    
  end
end

