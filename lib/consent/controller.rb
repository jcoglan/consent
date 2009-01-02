module Consent
  class Controller
    
    attr_reader :description, :name
    
    def initialize(description, name, params = nil)
      @description, @name, @params = description, name.to_s, params || {}
    end
    
    def controller_class
      "#{ @name }_controller".split('/').inject(Kernel) { |mod, name| mod.const_get(name.camelcase) }
    end
    
    def catchall_action
      Action.new(self, "", @params)
    end
    
    def /(action)
      action.module = @name
      action
    end
    
    def +(expression)
      expr = Expressions.new(@description)
      expr << self
      expr << expression
      expr
    end
    
    def module=(name)
      @name = "#{ name }/#{ @name }"
    end
    
    def method_missing(name, params = nil, &block)
      action = Action.new(self, name, params)
      @description.add_rule(action, &block) and return block if block_given?
      action
    end
    
    def http_restrict(verb)
      controller_class.class_eval do
        verify  :method => verb,
                :render => DENIAL_RESPONSE
      end
    end
    
  end
end

