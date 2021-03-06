# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
# FIXME: we could use 'undef' when rebuilding the template so that it's reloaded instead 
# of using cache_template_loading = false. 
config.action_view.cache_template_loading            = false # or zafu will not work !
Cache.perform_caching                                = true  # FIXME: these 2 settings do nothing. Do we need them ?
CachedPage.perform_caching                           = true 

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors if you bad email addresses should just be ignored
# config.action_mailer.raise_delivery_errors = false