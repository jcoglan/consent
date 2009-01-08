module Consent
  module Filters
    
    private
    def check_access_using_consent
      result = Consent.allows?(self)
      render(DENIAL_RESPONSE) and return false if result == false
      if Hash === result
        redirect_to(result[:redirect]) and return false if result[:redirect]
        render(result[:render]) and return false if result[:render]
      end
    end
    
  end
end

