# Copyright 2007-2008 Justin Perkins
# The R32 registry is distributed under the GNU General Public Licens. See license.txt or http://www.gnu.org/

class SearchController < ApplicationController
  def index
    @page_title = "Search For R32s"
    @search = { :value => params[:q], :mkiv => true, :mkv => true, :dbp => true, :bmp => true, :rs => true, :tr => true, :ug => true, :cw => true }
  end
end