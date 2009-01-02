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
        actions.each { |action| action.http_restrict(verb) }
      end
    end
    
    def add_rule(action, &block)
      @rules ||= []
      @rules << Rule.new(action, block)
    end
    
    def helper(name, &block)
      Context.__send__(:define_method, name, &block)
    end
    
  end
end

