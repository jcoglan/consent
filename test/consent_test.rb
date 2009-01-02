require 'test_helper'
require File.dirname(__FILE__) + '/../../../../config/environment'

%w(application site).each do |path|
  require File.dirname(__FILE__) + '/controllers/' + path + '_controller'
end

Consent::RULES_FILE = File.dirname(__FILE__) + '/rules.rb'

class ConsentTest < ActionController::TestCase
  tests SiteController
  
  test "allowed" do
    get :hello
    assert_response :success
  end
end
