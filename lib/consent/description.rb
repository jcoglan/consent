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
      class_eval <<-EOS
        def #{verb}(*exprs, &block)
          group = exprs.inject { |grp, expr| grp + expr }
          group.verb = :#{verb}
          Rule.push(@rules, group, block) if block_given?
          group
        end
      EOS
    end
    
    def method_missing(name, params = {}, &block)
      expr = Expression.new(self, name, params)
      Rule.push(@rules, expr, block) if block_given?
      expr
    end
    
  end
end

