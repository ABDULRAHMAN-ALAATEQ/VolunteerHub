require_relative 'boot'
require 'rails'
require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'rails/test_unit/railtie'
Bundler.require(*Rails.groups)
module VolunteerHub
  class Application < Rails::Application
    config.load_defaults 7.2
    config.public_file_server.enabled = true
    config.time_zone = 'Riyadh'
    config.active_record.default_timezone = :utc
    config.generators.system_tests = nil
    config.session_store :cookie_store, key: '_volunteer_hub_session', same_site: :lax
  end
end
