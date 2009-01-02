module Consent
  class Action
    
    attr_reader :name
    
    def initialize(controller, name)
      @controller, @name = controller, name.to_s
    end
    
    def matches?(params)
      @controller.name == params[:controller].to_s && @name == params[:action].to_s
    end
    
  end
end

