module Consent
  class Action
    
    attr_reader :name
    
    def initialize(controller, name)
      @controller, @name = controller, name.to_s
    end
    
    def matches?(context)
      p = context.params
      @controller.name == p[:controller].to_s && @name == p[:action].to_s
    end
    
  end
end

