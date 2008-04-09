class BlogsController < ApplicationController
  
  before_filter :login_required, :only => [ :mine, :add, :new, :delete, :fetch_for_edit, :edit ]
  before_filter :set_current_user
  verify :xhr => true, :only => [ :edit ], :redirect_to => '/'
  
  def index
    @page_title = 'R32 Owner Logs'
    @r32s = R32.active_logs

    @atom_settings = {
      :url => 'http://feeds.feedburner.com/us_r32_registry_all_owner_logs',
      :title => "Atom feed for all owner logs"
    }
  end
  
  def atom_for_all
    @page_title = "All Owner R32 logs"
    @entries = Post.find :all, :include => 'r32', :limit => 500, :order => 'posts.updated_at DESC'
    render :layout => false
  end
  
  def mine
    @page_title = 'Your R32 Logs'
    @r32s = @user.r32s
  end
  
  def new
    @r32 = R32.find params[:id]
    @page_title = "Owner Log for #{r32_to_s @r32}"
    render :action => 'show'
  end
  
  def add
    @r32 = R32.find params[:id]
    @page_title = "Owner Log for #{r32_to_s @r32}"
    if @r32.user_can_alter_this( @user )
      @post = Post.new params[:post]
      @post.r32 = @r32
      if @post.save

        @entries = @r32.posts.paginate :all, :page => @page, :order => 'created_at DESC', :per_page => 10

        respond_to do |format|
          format.html { redirect_to :action => 'show', :id => @r32.id }
          format.js do
            render :update do |page|
              page.call 'r32.toggleLogEntry'
              page.delay(0.5) do
                @post = nil
                page.replace_html 'add_log_entry_fieldset', :partial => 'form'
                page.replace_html 'posts', :partial => 'posts'
              end
            end
          end
        end
      else
        respond_to do |format|
          format.html { render :action => 'show' }
          format.js do
            render :update do |page|
              page.replace_html 'add_log_entry_fieldset', :partial => 'form'
            end
          end
        end
      end
    else
      redirect_to '/'
    end
  end
  
  def delete

    @post = Post.find params[:id]
    @r32 = @post.r32
    deleted = false

    if @r32.user_can_alter_this( @user )
      @post.destroy
      deleted = true
    end

    respond_to do |format|
      format.html { redirect_to :action => 'show', :id => @r32.id }
      format.js do
        render :update do |page|
          if deleted
            page.visual_effect :blind_up, "entry_#{@post.id}"
            page.delay(0.5) { page.remove "entry_#{@post.id}" }
          end
        end
      end
    end
  end
  
  def show
    @page = params[:page] || 1
    @r32 = R32.find params[:id]
    @entries = @r32.posts.paginate :all, :page => @page, :order => 'created_at DESC', :per_page => 10

    @atom_settings = {
      :url => url_for( :controller => '/blogs', :action => 'atom', :id => @r32.id ),
      :title => "Atom feed for log of #{ r32_to_s @r32 }"
    }
    @page_title = "Owner log of #{ r32_to_s @r32 }"
  end
  
  def single
    @entry = Post.find params[:id]
    @r32 = @entry.r32
  end

  def atom
    @r32 = R32.find params[:id]
    @page_title = "Owner log of #{ r32_to_s @r32 }"
    @entries = @r32.posts.find :all, :limit => 50, :order => 'updated_at DESC'
    render :layout => false
  end
    
  def fetch_for_edit
    @post = Post.find params[:id]
    @r32 = @post.r32

    text = 'not found'

    if @post && %{ title content }.include?( params[ :type ] )
      text = @post[ params[ :type ].to_sym ]
      selector = "#entry_#{ @post.id }_#{ params[:type] }-inplaceeditor .editor_field"
    end

    render :update do |page|
      page.select( selector ).first.value = text if selector
    end
  end
  
  def edit
    @post = Post.find params[:id]
    @r32 = @post.r32
    render :update do |page|
      if @r32.user_can_alter_this( @user )
        @post[params[:type].to_sym] = params[:value]
        @post.save
        updated_value = ''
        if params[:type] == 'title'
          updated_value = h @post.title
        else
          updated_value = format_text @post.content
        end
        page.replace_html "entry_#{@post.id}_#{params[:type]}", updated_value
      else
        page.redirect_to '/'
      end
    end
  end
  
  private
  def set_current_user
    @user = User.find session[:user_id] if session[:user_id]
  end
end