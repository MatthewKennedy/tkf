# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = Rails.application.credentials.dig(:sentry_dsn)

  # Only send events in these environments
  config.enabled_environments = %w[production staging]
  config.environment = Rails.env

  # Breadcrumbs: The "trail" leading to the error
  config.breadcrumbs_logger = [ :active_support_logger, :http_logger, :sentry_logger ]

  # Performance & Profiling
  # 1.0 is high for production; 0.1 (10%) is usually plenty.
  config.traces_sample_rate = 0.1
  config.profiles_sample_rate = 0.1

  # Data Privacy
  config.send_default_pii = true # Be careful: this sends user IPs and cookies.

  # Filtering
  config.excluded_exceptions += [ "SystemExit", "SignalException" ]

  # Use Rails' backtrace cleaner to make logs readable
  config.backtrace_cleanup_callback = lambda do |backtrace|
    Rails.backtrace_cleaner.clean(backtrace)
  end

  config.enable_logs = true
  config.enabled_patches << :logger
  config.std_lib_logger_filter = proc do |logger, message, severity|
    [ :error, :fatal ].include?(severity)
  end
end
