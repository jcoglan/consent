Consent.rules do
  
  site.goodbye(:id => 12)       { false }
  site.goodbye(:id => 45..60)   { false }
  site.goodbye(:id => "twelve") { false }
  site.goodbye(:id => /foo/i)   { false }
  
  site.hello                      +
  site.goodbye(:name => 'Jimmy')  +
  ajax/maps.find                  +
  http { params[:id] != 'fubar' }
  
  site(:id => 86)         +
  site(:id => /^never$/i) +
  ajax/maps(:id => 'stop') { false }
  
  get     site.hello,
          http.index
  post    http.update
  put     http.create
  delete  http.delete
  
  get ajax/maps
  
  ajax/maps.find { params[:id] != 'cancel' }
  
end

