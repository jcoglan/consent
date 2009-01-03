module Consent
  class Expression
    class Group
      
      include Enumerable
      attr_reader :description
      attr_accessor :block
      
      def initialize(description)
        @description, @exprs = description, []
      end
      
      def each(&block)
        @exprs.each(&block)
      end
      
      def +(expression)
        generate_rules!(expression.block) if expression.block
        Enumerable === expression ?
            expression.each { |expr| @exprs << expr } :
            @exprs << expression
        self
      end
      
      def verb=(verb)
        each { |expr| expr.verb = verb }
      end
      
    private
      
      def generate_rules!(block)
        each { |expr| @description.rules << Rule.new(expr, block) }
      end
      
    end
  end
end

