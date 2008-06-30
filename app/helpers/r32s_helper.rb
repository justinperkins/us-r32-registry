# Copyright 2007-2008 Justin Perkins
# The R32 registry is distributed under the GNU General Public Licens. See license.txt or http://www.gnu.org/

module R32sHelper
  def reverse_of_sort_direction( sort_direction )
    sort_direction == 'ASC' ? 'DESC' : 'ASC'
  end
  
  def url_for_sorting( active_sort, sort_by ,sort_direction )
    { :controller => '/r32s', 
      :action => 'index', 
      :chassis => ( @active_chassis ? @active_chassis : nil ),
      :sort_by => sort_by, 
      :sort_direction => ( active_sort == sort_by ? reverse_of_sort_direction( sort_direction ) : sort_direction )
    }
  end
  
  def sort_identifier_for_header( sort_by, sort_direction, column )
    sort_by == column ? ( sort_direction == 'ASC' ? '&darr;' : '&uarr;' ) : nil
  end
end
