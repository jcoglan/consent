Consent.rules do
  
  site.goodbye(:id => 12)       { false }
  site.goodbye(:id => "twelve") { false }
  site.goodbye(:id => /foo/i)   { false }
  
  site.hello(:env => 'dev') { test? }
  site.hello(:env => 'prod') { production? }
  
  site.goodbye(:id => 45..60) do
    allow if params[:id].to_i == 54
    false
  end
  
  site.hello                        +
  (site.goodbye(:name => 'Jimmy')   +
  ajax/maps.find)                   +
  http { params[:id] != 'fubar' }
  
  site(:id => 86)         +
  site(:id => /^never$/i) +
  ajax/maps(:id => 'stop') { false }
  
  post(http.index) + get(http.update(:name => 'duff') + http.create + http.delete) { false }
  http.create { request.put? }
  http.delete { request.delete? }
  
  post ajax/maps { false }
  
  http.index do
    redirect site if params[:user]
    allow
  end
  
  ajax/maps.find { params[:id] != 'cancel' }
  ajax/maps.find(:user => 'special') { redirect site.hello(:username => 'special') }
  
  helper(:user) { params[:user].upcase }
  put site.hello { user == 'JCOGLAN' }
  
end

