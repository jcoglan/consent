module Consent
  class Description
    
    attr_reader :rules
    
    def method_missing(name)
      Controller.new(self, name)
    end
    
    def add_rule(action, &block)
      @rules ||= []
      @rules << Rule.new(action, block)
    end
    
  end
end

