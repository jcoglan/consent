require 'active_support/string_inquirer'

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
    
    %w(development production test).each do |env|
      define_method("#{ env }?") { RAILS_ENV.to_s.downcase == env }
    end
    
    def format
      format = (@params[:format] || :html).to_s
      ActiveSupport::StringInquirer.new(format)
    end
    
  end
end

