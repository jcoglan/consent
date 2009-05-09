require File.dirname(__FILE__) + '/lib/consent'

app = RAILS_ROOT + '/app/controllers/application'
controller = app + '_controller'
require File.file?(controller + '.rb') ? controller : app

class ::Integer
  include Consent::Extensions::Integer
end

class ::ApplicationController
  include Consent::Extensions::UrlHelper
  include Consent::Filters
end

class ::ActionController::Routing::RouteSet
  include Consent::Extensions::Routing
end

class ::ActionView::Base
  include Consent::Extensions::UrlHelper
end

