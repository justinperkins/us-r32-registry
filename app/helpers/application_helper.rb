# Copyright 2007-2008 Justin Perkins
# The R32 registry is distributed under the GNU General Public Licens. See license.txt or http://www.gnu.org/

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def delete_entry_link(entry)
    link_to_remote( image_tag('trash.gif', :alt => 'delete this entry'), 
                   { :url => { :action => 'delete', :id => entry.id }, :confirm => 'Are you sure you want to delete this entry?' }, 
                   { :class => 'delete', 
                   :title => 'delete this entry' } ) if entry.r32.user_can_alter_this( @user )
  end
  
  def format_text(text)
    unless text.blank?
      text = sanitize text
      auto_link( text ).gsub( /\n/, '<br />' )
    end
  end
  
  def blog_mode?
    @controller.controller_name == 'blogs' && %w{ show new add single }.include?(@controller.action_name)
  end
  
  def viewing_user_profile?
    @controller.controller_name == 'account' && @controller.action_name == 'show'
  end
  
  def correct_case(chassis)
    chassis.upcase.gsub('K', 'k')
  end
  
  def opposite_chassis(chassis)
    case chassis
    when 'mkiv' then 'mkv'
    else 'mkiv'
    end
  end
  
  def r32_to_s(r32, options = {})
    options.reverse_merge!(:show_owner => true, :page_title => false)
    str = "#{abbreviated_color r32.color} #{correct_case r32.chassis}"
    if r32.totaled? && !options[:page_title]
      "This #{ str } has been totaled"
    elsif options[:show_owner]
      "#{ str }, Owner: #{r32.owner }" 
    else
      str
    end
  end
  
  def r32_brief(r32)
    str = []
    str << abbreviated_color(r32.color)
    str << correct_case(r32.chassis)
    str << (r32.edition_number.blank? ? 'unknown edition number' : "##{r32.edition_number}") if r32.chassis == 'mkv'
    str.join(' ')
  end
  
  def abbreviated_color(color)
    color.downcase == 'custom' ? 'Custom' : color.upcase
  end
  
  def format_date(date)
    date.strftime('%m/%d/%Y') if date
  end
  
  def author_is_viewing?(r32 = nil)
    r32 ||= @r32 if @r32
    @user && r32 && r32.user == @user
  end
  alias owner_is_viewing? author_is_viewing?
  
  def mail_to_admin
    @admin_user ||= User.find_an_admin
    mail_to @admin_user.email, @admin_user.email
  end
  
  def wants_adverts?
    @controller.controller_name != 'account' &&
    (@controller.controller_name == 'r32s' && !%w{ add edit }.include?(@controller.action_name))
  end
  
  def wrap_main?
    @controller.controller_name != 'blogs' &&
    (@controller.controller_name == 'r32s' && !%w{ add edit show }.include?(@controller.action_name))
  end
  
  def css_class_for_user(user)
    classes = []
    classes << 'member-contributor' if user && user.has_contributed?
    classes.join(' ')
  end
  
  def donate_link_for_contributor(user)
    return unless user.has_contributed?
    link_to('<span>contributor</span>', {:controller => 'about', :action => 'donate'}, :class => 'contributor', :title => "#{ h(user.display_name) } is a site contributor")
  end
end
