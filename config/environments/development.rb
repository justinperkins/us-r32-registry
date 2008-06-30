# Copyright 2007-2008 Justin Perkins
# The R32 registry is distributed under the GNU General Public Licens. See license.txt or http://www.gnu.org/

# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
config.action_view.cache_template_extensions         = false
config.action_view.debug_rjs                         = false

config.action_mailer.raise_delivery_errors = true
ActionMailer::Base.delivery_method = :smtp

GOOGLE_MAPS_API_KEY = 'ABQIAAAA8aehhaZXXdMRBZoQWFAjyBTJQa0g3IQ9GZqIMmInSLzwtGDKaBTOq-0a2l2ze8urHwyZewCnqSes1Q'