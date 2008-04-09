class SearchController < ApplicationController
  def index
    @page_title = "Search For R32s"
    @search = { :value => params[:q], :mkiv => true, :mkv => true, :dbp => true, :bmp => true, :rs => true, :tr => true, :ug => true, :cw => true }
  end
end