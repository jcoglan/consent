module Consent
  module Filters
    
    private
    def check_access_using_consent
      result = Consent.allows?(self)
      render(DENIAL_RESPONSE) and return false if result == false
      redirect_to(result) and return false if Hash === result
    end
    
  end
end

