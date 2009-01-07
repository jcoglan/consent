module Consent
  class Rule
    module Generator
      
      def self.included(base)
        base.module_eval do
          def rules; @rules ||= []; end
        end
      end
      
      def method_missing(name, params = {}, &block)
        expression = Rule::Expression.new(self, name, params)
        expression.rule!(block)
        expression
      end
      
      %w(get post put head delete).each do |verb|
        module_eval <<-EOS
          def #{verb}(*exprs, &block)
            group = exprs.inject { |grp, exp| grp + exp }
            group.verb = :#{verb}
            group.rule!(block)
            group
          end
        EOS
      end
      
    end
  end
end

