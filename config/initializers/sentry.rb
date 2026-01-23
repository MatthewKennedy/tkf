# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = Rails.application.credentials.dig(:sentry_dsn)
  config.environment = Rails.env
  config.breadcrumbs_logger = [ :active_support_logger, :http_logger ]
  config.send_default_pii = true
  config.traces_sample_rate = 1.0
  config.excluded_exceptions += [ "SystemExit" ]

  config.transport.options = {
    headers: {
      "CF-Access-Client-Id"     => Rails.application.credentials.dig(:cf_access_client_id),
      "CF-Access-Client-Secret" => Rails.application.credentials.dig(:cf_access_client_secret)
    }
  }
end unless Rails.env.development?
