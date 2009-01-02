require 'test_helper'
require File.dirname(__FILE__) + '/../../../../config/environment'

%w(application site http).each do |path|
  require File.dirname(__FILE__) + '/controllers/' + path + '_controller'
end

Consent::RULES_FILE = File.dirname(__FILE__) + '/rules.rb'

class ConsentTest < ActionController::TestCase
  tests SiteController
  
  test "allowed" do
    get :hello and assert_response :success
    get :goodbye, :id => 10 and assert_response :success
    get :goodbye, :id => "nothing" and assert_response :success
  end
  
  test "denied" do
    get :hello, :id => "something" and assert_response 403
    get :goodbye, :id => 12 and assert_response 403
    get :goodbye, :id => 50 and assert_response 403
    get :goodbye, :id => "food" and assert_response 403
  end
end

class HttpTest < ActionController::TestCase
  tests HttpController
  
  def test_allowed
    get :index and assert_response :success
    post :update and assert_response :success
    put :create and assert_response :success
    delete :delete and assert_response :success
  end
end

