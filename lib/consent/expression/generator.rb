module Consent
  class Expression
    module Generator
      
      def method_missing(name, params = {}, &block)
        generate_expression(name, params, &block)
      end
      
      def self.included(base)
        meths = base.instance_methods -
                Object.instance_methods.select { |m| m.to_s =~ /^__.*__$/ } -
                base.instance_methods(false) -
                instance_methods(false)
        
        meths = meths.map { |m| m.to_sym } - [:instance_eval]
        
        base.module_eval { undef_method(*meths) }
      end
      
    private
      
      def generate_expression(name, params, &block)
        Expression.new(self, name, params)
      end
      
    end
  end
end

