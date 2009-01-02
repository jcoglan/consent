module Consent
  class Description
    
    attr_reader :rules
    
    def method_missing(name, params = nil, &block)
      controller = Controller.new(self, name)
      add_rule(Action.new(controller, "", params), &block) if block_given?
      controller
    end
    
    %w(get post put head delete).each do |verb|
      define_method(verb) do |*actions|
        actions.each do |action|
          action.controller_class.class_eval do
            verify  :method => verb, :only => action.name,
                    :render => DENIAL_RESPONSE
          end
        end
      end
    end
    
    def add_rule(action, &block)
      @rules ||= []
      @rules << Rule.new(action, block)
    end
    
  end
end

