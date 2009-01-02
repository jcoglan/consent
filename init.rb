%w[
  consent
  consent/controller
  consent/action
  consent/rule
  consent/context
  consent/description
  consent/filters
].each do |file|
  require File.dirname(__FILE__) + '/lib/' + file
end

require RAILS_ROOT + '/app/controllers/application'

class ::ApplicationController
  include Consent::Filters
  before_filter :check_access_using_consent
end

