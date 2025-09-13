module Devise
  class CustomDeviseFailureApp < Devise::FailureApp
    def respond
      request.env["app.auth_failure_reason"] = i18n_message

      super
    end
  end
end
