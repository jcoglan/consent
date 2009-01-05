class SiteController < ApplicationController
  
  def hello
    render :text => 'hello'
  end
  
  def goodbye
    render :text => 'bye'
  end
  
  def redirector
    redirect_to ajax/maps.find
  end
  
end

