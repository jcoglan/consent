module Consent
  class Expression
    module Generator
      
      def method_missing(name, params = {}, &block)
        generate_expression(name, params, &block)
      end
      
    private
      
      def generate_expression(name, params, &block)
        Expression.new(self, name, params)
      end
      
    end
  end
end

