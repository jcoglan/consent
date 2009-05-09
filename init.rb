require File.dirname(__FILE__) + '/lib/consent'

app = RAILS_ROOT + '/app/controllers/application'
controller = app + '_controller'
require File.file?(controller + '.rb') ? controller : app

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

