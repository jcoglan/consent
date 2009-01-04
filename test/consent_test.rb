require 'test_helper'
require File.dirname(__FILE__) + '/../../../../config/environment'

%w(application site http ajax/maps allow_deny).each do |path|
  require File.dirname(__FILE__) + '/controllers/' + path + '_controller'
end

Consent::RULES_FILE = File.dirname(__FILE__) + '/rules.rb'

class ConsentTest < ActionController::TestCase
  tests SiteController
  
  test "allowed" do
    get :hello and assert_response :success
    get :goodbye, :id => 10 and assert_response :success
    get :goodbye, :id => 54 and assert_response :success
    get :hello, :id => "sometimes" and assert_response :success
    get :goodbye, :id => 87 and assert_response :success
    get :goodbye, :id => "nothing" and assert_response :success
    get :goodbye, :id => "fubar" and assert_response :success
    put :hello, :user => "jcoglan" and assert_response :success
    get :hello, :env => "dev" and assert_response :success
  end
  
  test "denied" do
    get :goodbye, :id => 12 and assert_response 403
    get :goodbye, :id => 50 and assert_response 403
    get :goodbye, :id => "food" and assert_response 403
    get :hello, :id => "fubar" and assert_response 403
    get :hello, :id => 86 and assert_response 403
    get :goodbye, :id => 86 and assert_response 403
    get :goodbye, :id => "NEVER" and assert_response 403
    get :hello, :id => "never" and assert_response 403
    get :goodbye, :id => "fubar", :name => "Jimmy" and assert_response 403
    put :hello, :user => "Jimmy" and assert_response 403
    get :hello, :env => "prod" and assert_response 403
  end
end
 
class HttpTest < ActionController::TestCase
  tests HttpController
  
  test "allowed" do
    get :index and assert_response :success
    get :index, :id => "allowed" and assert_response :success
    post :update and assert_response :success
    get :update, :name => "anything" and assert_response :success
    put :create and assert_response :success
    delete :delete and assert_response :success
  end
  
  test "redirected" do
    get :index, :user => "some guy"
    assert_redirected_to :controller => :site, :action => :index
  end
  
  test "denied" do
    get :index, :id => "fubar" and assert_response 403
    post :index and assert_response 403
    get :update, :name => "duff" and assert_response 403
    get :create and assert_response 403
    get :delete and assert_response 403
  end
end
 
class AjaxTest < ActionController::TestCase
  tests Ajax::MapsController
  
  test "allowed" do
    get :find and assert_response :success
    get :find, :id => 'anything' and assert_response :success
  end
  
  test "redirected" do
    get :find, :user => "special"
    assert_redirected_to :controller => :site, :action => :hello, :username => "special"
  end
  
  test "denied" do
    post :find and assert_response 403
    get :find, :id => 'fubar' and assert_response 403
    get :find, :id => 'stop' and assert_response 403
    get :find, :id => 'cancel' and assert_response 403
  end
end

class AllowDenyTest < ActionController::TestCase
  tests AllowDenyController
  
  test "allowed" do
    get :first, :id => "foo" and assert_response :success
    get :second, :id => "anything" and assert_response :success
    get :third, :id => "start" and assert_response :success
    get :fourth, :id => "allow" and assert_response :success
    
    # Ambiguous allow if/unless rules
    get :first, :id => "anything" and assert_response :success
    get :second, :id => "block" and assert_response :success
  end
  
  test "denied" do
    get :third, :id => "stop" and assert_response 403
    get :fourth, :id => "something" and assert_response 403
  end
end

