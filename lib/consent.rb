module Consent
  
  RULES_FILE = "#{ RAILS_ROOT }/config/consent.rb"
  
  DENIAL_RESPONSE = {:text => 'Access denied', :status => 403}
  
  def self.rules(&block)
    desc = Description.new
    desc.instance_eval(&block)
    @rules = desc.rules
  end
  
  def self.allows?(request, params, session)
    load RULES_FILE unless RAILS_ENV == "production" and @rules
    ctx = Context.new(request, params, session)
    @rules.nil? or @rules.all? { |rule| rule.check(ctx) }
  end
  
end

