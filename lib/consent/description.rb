module Consent
  class Description
    
    include Expression::Generator
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
    
  private
    
    def generate_expression(*args, &block)
      expr = super
      Rule.push(@rules, expr, block) if block_given?
      expr
    end
    
  end
end

