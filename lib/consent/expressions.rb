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
      block_given = (Proc === expression)
      @expressions << expression unless block_given
      each { |expr| @description.add_rule(expr, &expression) } if block_given
    end
    
    alias + <<
    
  end
end

