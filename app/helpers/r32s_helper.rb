# Copyright 2007-2008 Justin Perkins
# The R32 registry is distributed under the GNU General Public Licens. See license.txt or http://www.gnu.org/

module R32sHelper
  def reverse_of_sort_direction( sort_direction )
    sort_direction == 'ASC' ? 'DESC' : 'ASC'
  end
  
  def url_for_sorting( active_sort, sort_by ,sort_direction )
    { :controller => '/r32s', 
      :action => @controller.action_name, 
      :chassis => ( @active_chassis ? @active_chassis : nil ),
      :sort_by => sort_by, 
      :sort_direction => ( active_sort == sort_by ? reverse_of_sort_direction( sort_direction ) : sort_direction )
    }
  end
  
  def sort_identifier_for_header( sort_by, sort_direction, column )
    sort_by == column ? ( sort_direction == 'ASC' ? '&darr;' : '&uarr;' ) : nil
  end
  
  def r32_css_classes(r32)
    klass = []
    klass << 'preordered' if r32.preordered?
    klass << 'for_sale' if r32.for_sale?
    klass << 'totaled' if r32.totaled?
    klass.join(' ')
  end
  
  def r32_listing_legend
    legend = ''
    legend << content_tag(:span, 'Blue rows are preorders', :class => 'preordered')
    legend << ', '
    legend << content_tag(:span, 'red rows are for sale', :class => 'for_sale')
    legend << ' and '
    legend << content_tag(:span, 'black rows are totaled', :class => 'totaled')
    content_tag(:p, legend, :class => 'legend')
  end
end
