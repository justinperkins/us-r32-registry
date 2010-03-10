# Copyright 2007-2008 Justin Perkins
# The R32 registry is distributed under the GNU General Public Licens. See license.txt or http://www.gnu.org/

# Settings specified here will take precedence over those in config/environment.rb

# our production env has a funny version of ruby and we're using a really old version of rails
module ActionView
  module Helpers
    module TextHelper
      def truncate(text, length = 30, truncate_string = "...")
        if text.nil? then return end
        l = length - truncate_string.chars.to_a.size
        (text.chars.to_a.size > length ? text.chars.to_a[0...l].join + truncate_string : text).to_s
      end
    end
  end
end

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored

config.action_mailer.raise_delivery_errors = true
ActionMailer::Base.delivery_method = :sendmail

GOOGLE_MAPS_API_KEY = 'ABQIAAAA8aehhaZXXdMRBZoQWFAjyBR6cOTlX28qOZxGlxKhBWnYQihj0xQATe3yhOMqx8yuT-tZQgy_NxMTpA'                       