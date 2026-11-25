Rails.application.configure do
  config.enable_reloading = true
  config.eager_load = false
  config.consider_all_requests_local = true
  config.server_timing = true
  config.active_support.deprecation = :log
  config.secret_key_base = ENV.fetch('SECRET_KEY_BASE', 'development-only-volunteerhub-not-for-production-' * 3)
end
