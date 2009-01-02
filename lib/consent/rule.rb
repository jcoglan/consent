module Consent
  class Rule
    
    def initialize(action, block)
      @action, @predicate = action, block
    end
    
    def check(request, params, session)
      applies?(params) ? @predicate.call : true
    end
    
  private
    
    def applies?(params)
      @action.matches?(params)
    end
    
  end
end

