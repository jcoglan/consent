require 'observer'

module Consent
  class Rule
    class Expression < Consent::Expression
      
      include Observable
      attr_reader :block
      
      def initialize(env, name, params = {})
        super(name, params)
        @env = env
      end
      
      def *(expression)
        expression.destroy!
        rule!(expression.block)
        super
      end
      
      def method_missing(name, params = {}, &block)
        rule!(block)
        super(name, params)
      end
      
      def destroy!
        changed(true)
        notify_observers(:destroyed)
      end
      
      def rule!(block)
        return if block.nil?
        @block = block
        @env.rules << Rule.new(self, block)
      end
      
      class Group < Consent::Expression::Group
        attr_reader :block
        
        def +(expression)
          rule!(expression.block)
          super
        end
        
        def rule!(block)
          return if block.nil?
          @block = block
          each { |exp| exp.rule!(block) }
        end
      end
      
    end
  end
end

