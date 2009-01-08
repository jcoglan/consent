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
  
  def self.allows?(controller)
    load RULES_FILE if RAILS_ENV == "development" or @rules.nil?
    return true if @rules.nil?
    
    ctx = Context.new(controller)
    @rules.each do |rule|
      result = rule.check(ctx)
      next if result == true
      
      ctx.log("\n[Consent firewall] matched #{ rule.inspect }")
      ctx.log(  "                   BLOCKED") if result == false
      ctx.log(  "                   REDIRECTED to #{ Expression.from_hash(result).inspect }") if Hash === result
      ctx.log(  "                   rule: #{ rule.line_number }")
      
      ctx.log("\n")
      
      return result
    end
    true
  end
  
  def self.flush_throttles!
    return if @rules.nil?
    @rules.each { |rule| rule.flush_throttles! }
  end
  
end

