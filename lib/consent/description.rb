module Consent
  class Description
    
    attr_reader :rules
    
    def initialize
      @rules = []
    end
    
    def helper(name, &block)
      Context.__send__(:define_method, name, &block)
    end
    
    %w(get post put head delete).each do |verb|
      define_method(verb) do |*exprs|
        exprs.each { |expr| expr.http_restrict(verb) }
      end
    end
    
    def method_missing(name, params = {}, &block)
      expr = Expression.new(self, name, params)
      @rules << Rule.new(expr, block) if block_given?
      expr
    end
    
  end
end

