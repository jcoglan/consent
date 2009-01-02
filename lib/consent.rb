module Consent
  
  RULES_FILE = "#{ RAILS_ROOT }/config/consent.rb"
  
  def self.rules
    puts "loading Consent rules"
  end
  
  def self.allows?(request, params, session)
    load RULES_FILE unless RAILS_ENV == "production" and @rules
    true
  end
  
end

