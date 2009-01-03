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
      p, req = context.params, context.request
      
      return false if (@controller != p[:controller].to_s)      or
                      (@action and @action != p[:action].to_s)  or
                      (@verb and !req.__send__("#{ @verb }?"))
      
      @params.all? do |key, value|
        (value == p[key])  || (value == p[key].to_s) ||
        (value === p[key]) || (value === p[key].to_i)
      end
    end
    
    def verb=(verb)
      @verb = verb
    end
    
  private
    
    def controller_class
      "#{ @controller }_controller".split('/').inject(Kernel) do |mod, name|
        mod.const_get(name.camelcase)
      end
    end
    
  end
end

