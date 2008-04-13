RAILS_GEM_VERSION = '1.2.3'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here
  
  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Only load the plugins named here, by default all plugins in vendor/plugins are loaded
  # config.plugins = %W( exception_notification ssl_requirement )

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level 
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper, 
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
  
  # See Rails::Configuration for more options
end

# set errors on inputs/selects to be wrapped with a span instead of the default div
ActionView::Base.field_error_proc = Proc.new{ |html_tag, instance|
  "<span class=\"fieldWithErrors\">#{html_tag}</span>" 
}

salts = "#{RAILS_ROOT}/lib/salts.rb"
load(salts) if File.exist?(salts)
GLOBAL_SALT = 'salty goodness' unless defined? GLOBAL_SALT

# Allow per-developer configuration settings in "#{$RAILS_ROOT}/.railsrc"
# http://weblog.jamisbuck.org/2007/2/1/per-developer-configuration
if RAILS_ENV != "production" 
  railsrc = "#{RAILS_ROOT}/.railsrc"
  load(railsrc) if File.exist?(railsrc)
end