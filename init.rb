require File.dirname(__FILE__) + '/lib/consent'

require RAILS_ROOT + '/app/controllers/application'

class ::ApplicationController
  include Consent::Extensions::Controller
  include Consent::Filters
  before_filter :check_access_using_consent
end

class ::ActionController::Routing::RouteSet
  include Consent::Extensions::Routing
end

