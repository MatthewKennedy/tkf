Sentry.init do |config|
  config.dsn = Rails.application.credentials.dig(:sentry_dsn)
  config.environment = Rails.env
  config.enabled_environments = %w[production staging uat]

  # 1. Enable the new Structured Logs feature
  config.enable_logs = true

  # 2. Patch the standard Ruby Logger so Rails.logger.info(...)
  # automatically flows into Sentry's Logs UI
  config.enabled_patches << :logger

  # 3. Capture everything from INFO upwards
  config.std_lib_logger_filter = proc do |logger, message, severity|
    [ :info, :warn, :error, :fatal ].include?(severity)
  end

  # 4. Keep breadcrumbs for error context (very low overhead)
  config.breadcrumbs_logger = [ :active_support_logger, :http_logger, :sentry_logger ]

  # 5. Performance Monitoring (Adjust rates based on your server hardware)
  config.traces_sample_rate = 0.5   # 50% of requests
  config.profiles_sample_rate = 0.1 # 10% for deep function-level analysis

  config.before_send_transaction = lambda do |event, hint|
    if event.transaction&.include?("up") || event.transaction&.include?("healthz")
      nil
    else
      event
    end
  end

  # 6. Cleanup
  config.excluded_exceptions += [ "SystemExit", "SignalException" ]

  config.backtrace_cleanup_callback = lambda do |backtrace|
    Rails.backtrace_cleaner.clean(backtrace)
  end
end
