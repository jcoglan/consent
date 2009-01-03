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
      applies?(context) ? context.instance_eval(&@predicate) : true
    end
    
  private
    
    def applies?(context)
      @expression === context
    end
    
  end
end

