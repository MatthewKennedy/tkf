# frozen_string_literal: true

require "sentry/transport/http_transport"

module Sentry
  class CloudflareTransport < HTTPTransport
    def send_data(data)
      @headers ||= {}

      client_id = ::Rails.application.credentials.dig(:cf_access_client_id)
      client_secret = ::Rails.application.credentials.dig(:cf_access_client_secret)

      if client_id && client_secret
        @headers["CF-Access-Client-Id"] = client_id.to_s
        @headers["CF-Access-Client-Secret"] = client_secret.to_s
      end

      super(data)
    end
  end
end

Sentry.init do |config|
  config.dsn = Rails.application.credentials.dig(:sentry_dsn)
  config.environment = Rails.env
  config.breadcrumbs_logger = [ :active_support_logger, :http_logger ]
  config.send_default_pii = true
  config.traces_sample_rate = 1.0
  config.excluded_exceptions += [ "SystemExit" ]
  config.transport.transport_class = Sentry::CloudflareTransport
end unless Rails.env.development?
