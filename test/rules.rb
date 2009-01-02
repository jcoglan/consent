Consent.rules do
  
  site.hello { params[:id].nil? }
  site.goodbye(:id => 12) { false }
  site.goodbye(:id => 45..60) { false }
  site.goodbye(:id => "twelve") { false }
  site.goodbye(:id => /foo/i) { false }
  
  get     site.hello,
          http.index
  post    http.update
  put     http.create
  delete  http.delete
  
end

