require File.dirname(__FILE__) + '/lib/consent'

require RAILS_ROOT + '/app/controllers/application'

class ::Integer
  include Consent::Extensions::Integer
end

class ::ApplicationController
  include Consent::Extensions::Controller
  include Consent::Filters
end

class ::ActionController::Routing::RouteSet
  include Consent::Extensions::Routing
end

