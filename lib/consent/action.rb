module Consent
  class Action
    
    attr_reader :name
    
    def initialize(controller, name, params = nil)
      @controller, @name, @params = controller, name.to_s, params || {}
    end
    
    def controller_class
      Kernel.const_get("#{ @controller.name.camelcase }Controller")
    end
    
    def matches?(context)
      p = context.params
      @controller.name == p[:controller].to_s &&
          @name == p[:action].to_s &&
          @params.all? do |key, value|
            (value == p[key])  || (value.to_s == p[key]) ||
            (value === p[key]) || (value === p[key].to_i)
          end
    end
    
  end
end

