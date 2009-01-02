module Consent
  class Description
    
    attr_reader :rules
    
    def method_missing(name)
      Controller.new(self, name)
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

