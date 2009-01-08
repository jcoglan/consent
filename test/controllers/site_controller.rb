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
  
  def throttled
    render :text => 'You got through!'
  end
  
  def bm
    render :text => 'bm'
  end
  
end

