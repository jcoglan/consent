Consent.rules do
  
  site.goodbye(:id => 12)       { false }
  site.goodbye(:id => "twelve") { false }
  site.goodbye(:id => /foo/i)   { false }
  
  site.hello.xml { deny unless params[:name] == 'rss' }
  site.goodbye { deny if format.json? }
  http * xml { deny }
  
  http * site { deny }  # Should block nothing
  
  site.hello(:env => 'dev') { test? }
  site.hello(:env => 'prod') { production? }
  
  site.goodbye(:id => 45..60) do
    allow if params[:id].to_i == 54
    false
  end
  
  site*json { throttle params[:x], 3.per_second }
  site.throttled { throttle params[:u], 3.per_second }
  site.throttled { deny if params[:ignore] }
  
  site.bm { throttle :all, 5.per_second if params[:user] == 'banned' }
  
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
  ajax/maps.find(:user => 'special') { redirect site.hello(:username => 'special').xml }
  
  helper(:user) { params[:user].upcase }
  put site.hello { user == 'JCOGLAN' }
  
  allow_deny.first    { allow if params[:id] == "foo" }
  allow_deny.second   { allow unless params[:id] == "block" }
  allow_deny.third    { deny if params[:id] == "stop" }
  allow_deny.fourth   { deny unless params[:id] == "allow" }
  
end

