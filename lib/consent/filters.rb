module Consent
  module Filters
    
    def check_access_using_consent
      render(DENIAL_RESPONSE) and return false unless Consent.allows?(request, params, session)
    end
    
  end
end

