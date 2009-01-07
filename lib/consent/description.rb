module Consent
  class Description
    
    include Rule::Generator
    
    def helper(name, &block)
      Context.class_eval { define_method(name, &block) }
    end
    
  end
end

