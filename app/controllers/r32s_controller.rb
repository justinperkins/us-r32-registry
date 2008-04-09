require 'login_system'

class R32sController < ApplicationController
  before_filter :login_required, :only => [ :edit, :delete ]
  before_filter :set_current_user
  
  def index
    @page = safe_page( params[ :page ] )
    @active_chassis = safe_input( params[:chassis], %w{ mkiv mkv } )
    @sort_by = safe_input( params[:sort_by], [ 'r32s.chassis', 'r32s.color', 'r32s.interior', 'r32s.edition_number', 'r32s.purchased_on', 'r32s.for_sale', 'r32s.preordered', 'users.first_name', 'users.city' ], 'r32s.created_at' )
    @sort_direction = safe_input( params[:sort_direction], %w{ ASC DESC }, 'ASC' )

    @page_title = "All #{"#{correct_case @active_chassis.upcase} " if @active_chassis}R32s"
    @page_title << " (Page #{ @page })" unless @page == 1

    
    if @active_chassis
      @all_r32s = R32.find_all_by_chassis @active_chassis
      @most_recent_for_chassis = R32.find :all, :include => 'user', :conditions => [ 'chassis = ?', @active_chassis ], :limit => 1, :order => 'r32s.created_at DESC'
      @atom_settings = {
        :url => "http://feeds.feedburner.com/us_r32_registry_all_#{ @active_chassis }_r32s",
        :title => "Atom feed for all #{ correct_case @active_chassis } R32s"
      }
    else
      @all_r32s = R32.find :all
      @most_recent_mkiv = R32.find :all, :include => 'user', :conditions => [ 'chassis = ?', 'mkiv' ], :limit => 1, :order => 'r32s.created_at DESC'
      @most_recent_mkv = R32.find :all, :include => 'user', :conditions => [ 'chassis = ?', 'mkv' ], :limit => 1, :order => 'r32s.created_at DESC'
      @atom_settings = {
        :url => 'http://feeds.feedburner.com/us_r32_registry_all_r32s',
        :title => "Atom feed for all R32s"
      }
    end

    @r32s = (@active_chassis ? R32.paginate_all_by_chassis(@active_chassis, :include => 'user', :order => "#{ @sort_by } #{ @sort_direction }", :page => @page ) : R32.paginate(:all, :include => 'user', :order => " #{ @sort_by } #{ @sort_direction }", :page => @page ))
  end
  
  def atom
    @active_chassis = params[ :id ]
    if @active_chassis && %w{ mkiv mkv }.include?( @active_chassis )
      @entries = R32.find :all, :limit => 100, :conditions => [ 'chassis = ?', @active_chassis ], :include => 'user', :order => 'r32s.created_at DESC'
      @page_title = "All registered US-spec #{ correct_case @active_chassis } R32s"
    elsif @active_chassis == 'for_sale'
      @entries = R32.find :all, :limit => 100, :conditions => [ 'for_sale = ?', true ], :include => 'user', :order => 'r32s.created_at DESC'
      @page_title = "All registered US-spec R32s that are currently for sale"
    else
      @entries = R32.find :all, :limit => 100, :include => 'user', :order => 'r32s.created_at DESC'
      @page_title = "All registered US-spec R32s"
    end
    
    render :layout => false
  end
  
  def show
    @r32 = R32.find params[:id]
    @page_title = "#{r32_to_s @r32}"
  end
  
  def for_sale
    @r32s = R32.find_all_by_for_sale true
    @page_title = @r32s ? "#{@r32s ? @r32s.size : 0} #{@r32s && @r32s.size > 1 ? 'R32s' : 'R32'} For Sale" : 'R32s For Sale'
    @atom_settings = {
      :url => "http://feeds.feedburner.com/us_r32_registry_all_r32s_for_sale",
      :title => "Atom feed for all R32s that are currently for sale"
    }
  end
  
  def about
    @page_title = "About the R32"
  end
  
  def map
    @page_title = 'R32s on a map'
    @active_chassis = safe_input( params[:chassis], %w{ mkiv mkv } )
    @r32s = R32.find_all_with_latitude_and_longitude( @active_chassis )
  end
  
  def delete
    if @user.is_admin?
      R32.destroy params[:id]
      flash[:notice] = 'R32 Deleted'
    end
    redirect_to '/'
  end
  
  def add
    unless session[:user_id]
      flash[:notice] = "You'll Need to Login or Create an Account Before Adding Your R32"
      redirect_to :controller => 'account', :action => 'create'
      return
    end
    
    @page_title = 'Add Your R32'
    case request.method
    when :post
      @r32 = @user.r32s.new params[:r32]
      @r32.user = @user
      if @r32.save
        flash[:notice] = "Your R32 Was Added"
        redirect_to :controller => 'account', :action => 'show', :id => session[:user_id]
      end
    when :get
      @r32 = @user.r32s.new
    end
  end
  
  def edit
    @page_title = 'Edit Your R32'
    @r32 = R32.find params[:id]
    if @r32.user_can_alter_this( @user )
      case request.method
      when :post
        if @r32.update_attributes params[:r32]
          flash.now[:notice] = 'Changes Saved'
        end
      when :get
      end
    else
      redirect_to '/'
    end
  end
  
  private
  def correct_case chassis
    chassis.upcase.gsub('K', 'k')
  end
  
  def set_current_user
    @user = User.find session[:user_id] if session[:user_id]
  end
  
  def safe_input( input, allowed_strings, default = nil )
    allowed_strings.include?( input ) ? input : default
  end
  
  def safe_page( page = nil )
    page =~ /\d+/ ? page : 1
  end
end