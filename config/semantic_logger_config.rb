module Configuration
  SEMANTIC_LOGGER_CONFIG = lambda do |config|
    config.semantic_logger.application = "tkf"
    config.semantic_logger.environment = ENV["STACK_NAME"] || Rails.env

    config.rails_semantic_logger.add_file_appender = false

    config.log_level = ENV["LOG_LEVEL"] || :info
    config.log_tags = {
      source: "rails"
    }

    if ENV["LOG_TO_CONSOLE"] || ENV["KUBERNETES_SERVICE_HOST"]
      config.semantic_logger.add_appender(io: $stdout, formatter: :json)
    end
  end
end

if defined?(SemanticLogger) && !!Rails.application.credentials.dig(:sentry_dsn)
  SemanticLogger.add_appender(
    appender: :sentry,
    level: :info
  ) do |log|
    !log.message.to_s.match?(%r{GET /(up|healthz)})
  end
end
