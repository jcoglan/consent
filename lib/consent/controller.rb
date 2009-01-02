module Consent
  class Controller
    
    attr_reader :name
    
    def initialize(description, name)
      @description, @name = description, name.to_s
    end
    
    def method_missing(name, params = nil, &block)
      action = Action.new(self, name, params)
      @description.add_rule(action, &block) if block_given?
      action
    end
    
  end
end

