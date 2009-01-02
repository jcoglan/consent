module Consent
  class Context
    
    attr_reader :request, :params, :session
    
    def initialize(request, params, session)
      @request, @params, @session = request, params, session
    end
    
  end
end

