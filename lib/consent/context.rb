module Consent
  class Context
    
    include Expression::Generator
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
    
    def redirect(expression)
      raise RedirectException.new(expression)
    end
    
  end
end

