# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def delete_entry_link( entry )
    link_to_remote( image_tag('trash.gif', :alt => 'delete this entry'), 
                   { :url => { :action => 'delete', :id => entry.id }, :confirm => 'Are you sure you want to delete this entry?' }, 
                   { :class => 'delete', 
                   :title => 'delete this entry' } ) if entry.r32.user_can_alter_this( @user )
  end
  
  def format_text( text )
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
  
  def correct_case( chassis )
    chassis.upcase.gsub('K', 'k')
  end
  
  def opposite_chassis( chassis )
    case chassis
    when 'mkiv' then 'mkv'
    else 'mkiv'
    end
  end
  
  def r32_to_s r32, show_owner = true
    "#{abbreviated_color r32.color} #{correct_case r32.chassis} R32#{ ", Owner: #{r32.owner}" if show_owner}"
  end
  
  def abbreviated_color( color )
    color.downcase == 'custom' ? 'Custom' : color.upcase
  end
  
  def format_date( date )
    date.strftime('%m/%d/%Y') if date
  end
  
  def r32_in_place_editor( field_id, options = {} )
    function =  "new Ajax.R32InPlaceEditor("
    function << "'#{field_id}', "
    function << "'#{url_for(options[:url])}'"

    js_options = {}
    js_options['cancelText'] = %('#{options[:cancel_text]}') if options[:cancel_text]
    js_options['okText'] = %('#{options[:save_text]}') if options[:save_text]
    js_options['loadingText'] = %('#{options[:loading_text]}') if options[:loading_text]
    js_options['savingText'] = %('#{options[:saving_text]}') if options[:saving_text]
    js_options['rows'] = options[:rows] if options[:rows]
    js_options['cols'] = options[:cols] if options[:cols]
    js_options['size'] = options[:size] if options[:size]
    js_options['externalControl'] = "'#{options[:external_control]}'" if options[:external_control]
    js_options['loadTextURL'] = "'#{url_for(options[:load_text_url])}'" if options[:load_text_url]        
    js_options['ajaxOptions'] = options[:options] if options[:options]
    js_options['evalScripts'] = options[:script] if options[:script]
    js_options['callback']   = "function(form) { return #{options[:with]} }" if options[:with]
    js_options['clickToEditText'] = %('#{options[:click_to_edit_text]}') if options[:click_to_edit_text]
    js_options['doubleClickToEdit'] = true if options[:double_click_to_edit]
    function << (', ' + options_for_javascript(js_options)) unless js_options.empty?

    function << ')'

    javascript_tag(function)
  end
  
  def author_is_viewing?( r32 = nil )
    r32 ||= @r32 if @r32
    @user && r32 && r32.user == @user
  end
  
  def mail_to_admin
    @admin_user ||= User.find_an_admin
    mail_to @admin_user.email, @admin_user.email
  end
  
  alias owner_is_viewing? author_is_viewing?
end
