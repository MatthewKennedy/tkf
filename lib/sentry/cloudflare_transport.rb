require "sentry/transport/http_transport"

module Sentry
  class CloudflareTransport < HTTPTransport
    def send_data(data)
      headers = {
        "CF-Access-Client-Id"     => Rails.application.credentials.dig(:cf_access_client_id),
        "CF-Access-Client-Secret" => Rails.application.credentials.dig(:cf_access_client_secret)
      }.compact

      @headers.merge!(headers)

      super(data)
    end
  end
end
