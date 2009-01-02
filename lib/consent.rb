module Consent
  
  RULES_FILE = "#{ RAILS_ROOT }/config/consent.rb"
  
  def self.rules(&block)
    desc = Description.new
    desc.instance_eval(&block)
    @rules = desc.rules
  end
  
  def self.allows?(request, params, session)
    load RULES_FILE unless RAILS_ENV == "production" and @rules
    @rules.nil? or @rules.all? { |rule| rule.check(request, params, session) }
  end
  
end

