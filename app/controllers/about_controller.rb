# Copyright 2007-2008 Justin Perkins
# The R32 registry is distributed under the GNU General Public Licens. See license.txt or http://www.gnu.org/

class AboutController < ApplicationController

  def index
    @page_title = "Let's Get Meta!"
  end
  
  def adverts
    @page_title = "You've got to feed the monkey"
  end
  
  def feeds
    @page_title = 'RSS Feeds for your needs'
  end
end
