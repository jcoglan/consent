module Consent
  class Context
    
    attr_reader :request, :params, :session
    
    def initialize(request, params, session)
      @request, @params, @session = request, params, session
    end
    
    def deny
      raise DenyException
    end
    
    def allow
      raise AllowException
    end
    
  end
end

