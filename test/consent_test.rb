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
    get :hello, :id => "sometimes" and assert_response :success
    get :goodbye, :id => 87 and assert_response :success
    get :goodbye, :id => "nothing" and assert_response :success
    get :goodbye, :id => "fubar" and assert_response :success
  end
  
  test "denied" do
    get :goodbye, :id => 12 and assert_response 403
    get :goodbye, :id => 50 and assert_response 403
    get :goodbye, :id => "food" and assert_response 403
    post :hello and assert_response 403
    get :hello, :id => "fubar" and assert_response 403
    get :hello, :id => 86 and assert_response 403
    get :goodbye, :id => 86 and assert_response 403
    get :goodbye, :id => "never" and assert_response 403
    get :hello, :id => "never" and assert_response 403
    get :goodbye, :id => "fubar", :name => "Jimmy" and assert_response 403
  end
end

class HttpTest < ActionController::TestCase
  tests HttpController
  
  test "allowed" do
    get :index and assert_response :success
    get :index, :id => "allowed" and assert_response :success
    post :update and assert_response :success
    put :create and assert_response :success
    delete :delete and assert_response :success
  end
  
  test "denied" do
    get :index, :id => "fubar" and assert_response 403
    post :index and assert_response 403
    put :update and assert_response 403
    delete :create and assert_response 403
    get :delete and assert_response 403
  end
end

