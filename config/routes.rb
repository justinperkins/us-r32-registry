# Copyright 2007-2008 Justin Perkins
# The R32 registry is distributed under the GNU General Public Licens. See license.txt or http://www.gnu.org/

ActionController::Routing::Routes.draw do |map|
  map.connect '', :controller => "r32s"
  map.connect 'mkiv/r32s', :controller => 'r32s', :chassis => 'mkiv'
  map.connect 'mkv/r32s', :controller => 'r32s', :chassis => 'mkv'

  map.connect ':controller/service.wsdl', :action => 'wsdl'

  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
