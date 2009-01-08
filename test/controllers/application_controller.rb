class ApplicationController < ActionController::Base
  
  protect_from_forgery
  before_filter :check_access_using_consent
  
end

