# Copyright 2007-2008 Justin Perkins
# The R32 registry is distributed under the GNU General Public Licens. See license.txt or http://www.gnu.org/

class SearchController < ApplicationController
  def index
    @page_title = "Search For R32s"
    unless params[:q].blank?
      @edition_match = R32.find_by_chassis_and_edition_number('mkv', params[:q])
      @vin_matches = R32.find(:all, :conditions => ['LOWER(vin) LIKE ?', "%#{ params[:q].downcase }"])
    end
  end
end