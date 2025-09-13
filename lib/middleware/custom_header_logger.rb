module Middleware
  class CustomHeaderLogger
    def initialize(app)
      @app = app
    end

    def call(env)
      binding.break
      # Extract the custom header (e.g., 'X-Custom-Header')
      custom_header = env["HTTP_X_CUSTOM_HEADER"] || "N/A"
      # Store it in a thread-local variable for the logger to access
      Thread.current[:custom_header] = "custom_header"
      @app.call(env)
    ensure
      # Clean up to avoid memory leaks
      Thread.current[:custom_header] = nil
    end
  end
end
