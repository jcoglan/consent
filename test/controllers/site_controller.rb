class SiteController < ApplicationController
  
  def hello
    render :text => 'hello'
  end
  
  def goodbye
    render :text => 'bye'
  end
  
end

