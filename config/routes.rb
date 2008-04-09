ActionController::Routing::Routes.draw do |map|
  map.connect '', :controller => "r32s"
  map.connect 'mkiv/r32s', :controller => 'r32s', :chassis => 'mkiv'
  map.connect 'mkv/r32s', :controller => 'r32s', :chassis => 'mkv'

  map.connect ':controller/service.wsdl', :action => 'wsdl'

  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
