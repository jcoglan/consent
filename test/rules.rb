Consent.rules do
  
  site.goodbye(:id => 12) { false }
  site.goodbye(:id => 45..60) { false }
  site.goodbye(:id => "twelve") { false }
  site.goodbye(:id => /foo/i) { false }
  
  restrict(site.hello, site.goodbye(:name => 'Jimmy'), http) { params[:id] != 'fubar' }
  
  restrict(site(:id => 86), site(:id => /^never$/i)) { false }
  
  get     site.hello,
          http.index
  post    http.update
  put     http.create
  delete  http.delete
  
end

