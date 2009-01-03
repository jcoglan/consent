module Consent
  class Expression
    
    attr_accessor :block
    
    def initialize(description, controller, params = {})
      @description, @controller, @params = description, controller.to_s, params
    end
    
    def +(expression)
      group = Group.new(@description)
      group + self + expression
    end
    
    def /(expression)
      expression.nesting = @controller
      expression
    end
    
    def nesting=(name)
      @controller = "#{ name }/#{ @controller }"
    end
    
    def method_missing(name, params = {}, &block)
      @action = name.to_s
      @params.update(params)
      @description.rules << Rule.new(self, block) if block_given?
      self
    end
    
    def ===(context)
      p = context.params
      return false unless @controller == p[:controller].to_s
      return false if @action and @action != p[:action].to_s
      @params.all? do |key, value|
        (value == p[key])  || (value == p[key].to_s) ||
        (value === p[key]) || (value === p[key].to_i)
      end
    end
    
    def http_restrict(verb)
      options = {:method => verb, :render => DENIAL_RESPONSE}
      options[:only] = @action if @action
      controller_class.class_eval { verify(options) }
    end
    
  private
    
    def controller_class
      "#{ @controller }_controller".split('/').inject(Kernel) do |mod, name|
        mod.const_get(name.camelcase)
      end
    end
    
    class Group
      
      include Enumerable
      attr_reader :description
      
      def initialize(description)
        @description, @exprs = description, []
      end
      
      def each(&block)
        @exprs.each(&block)
      end
      
      def +(expression)
        generate_rules!(expression.block) if expression.block
        @exprs << expression
        self
      end
      
    private
      
      def generate_rules!(block)
        each { |expr| @description.rules << Rule.new(expr, block) }
      end
      
    end
    
  end
end

