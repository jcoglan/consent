module Consent
  class Action
    
    attr_reader :name, :params
    
    def initialize(controller, name, params = nil)
      @controller, @name, @params = controller, name.to_s, params || {}
    end
    
    def controller_class
      @controller.controller_class
    end
    
    def module=(name)
      @controller.module = name
    end
    
    def matches?(context)
      p = context.params
      @controller.name == p[:controller].to_s &&
          (@name == "" || @name == p[:action].to_s) &&
          @params.all? do |key, value|
            (value == p[key])  || (value.to_s == p[key]) ||
            (value === p[key]) || (value === p[key].to_i)
          end
    end
    
    def http_restrict(verb)
      name = @name
      controller_class.class_eval do
        verify  :method => verb, :only => name,
                :render => DENIAL_RESPONSE
      end
    end
    
  end
end

