Consent.rules do
  
  site.goodbye(:id => 12)       { false }
  site.goodbye(:id => 45..60)   { false }
  site.goodbye(:id => "twelve") { false }
  site.goodbye(:id => /foo/i)   { false }
  
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
  
  ajax/maps.find { params[:id] != 'cancel' }
  
  helper(:user) { params[:user].upcase }
  put site.hello { user == 'JCOGLAN' }
  
end

