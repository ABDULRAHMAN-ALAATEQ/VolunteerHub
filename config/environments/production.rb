Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.public_file_server.enabled = true
  config.force_ssl = true
  config.log_level = :info
  config.secret_key_base = ENV.fetch('SECRET_KEY_BASE')
end
