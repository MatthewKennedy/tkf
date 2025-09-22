Recaptcha.configure do |config|
  config.site_key   = Rails.application.credentials.dig(:recaptcha, :site_key) || ENV["SITE_KEY"]
  config.secret_key = Rails.application.credentials.dig(:recaptcha, :secret_key) || ENV["SECRET_KEY"]

  # Uncomment the following lines if you are using the Enterprise API:
  config.enterprise            = true
  config.enterprise_api_key    = Rails.application.credentials.dig(:recaptcha, :enterprise_api_key) || ENV["ENTERPRISE_API_KEY"]
  config.enterprise_project_id = Rails.application.credentials.dig(:recaptcha, :enterprise_project_id) || ENV["ENTERPRISE_PROJECT_ID"]
end
