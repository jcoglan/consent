module Consent
  
  RULES_FILE = "#{ RAILS_ROOT }/config/consent.rb"
  
  DENIAL_RESPONSE = {:text => 'Access denied', :status => 403}
  
  class DenyException < Exception; end
  class AllowException < Exception; end
  
  class RedirectException < Exception
    attr_reader :params
    def initialize(expression)
      @params = expression.to_h
    end
  end
  
  def self.rules(&block)
    desc = Description.new
    desc.instance_eval(&block)
    @rules = desc.rules
  end
  
  def self.allows?(request, params, session)
    load RULES_FILE if RAILS_ENV == "development" or @rules.nil?
    return true if @rules.nil?
    ctx = Context.new(request, params, session)
    @rules.each do |rule|
      result = rule.check(ctx)
      return result unless result == true
    end
    true
  end
  
end

