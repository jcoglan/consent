module Consent
  class Expressions
    
    include Enumerable
    
    def initialize(description)
      @description = description
      @expressions = []
    end
    
    def each(&block)
      @expressions.each(&block)
    end
    
    def <<(expression)
      if expression.block
        each { |expr| @description.add_rule(expr, &expression.block) }
      else
        @expressions << expression
      end
    end
    
    alias + <<
    
  end
end

