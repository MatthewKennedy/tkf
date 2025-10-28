module Spree
  class PasswordsController < ::Devise::PasswordsController
    include Spree::Storefront::DeviseConcern

    # POST /resource/password
    def create
      verify_recaptcha_success = verify_recaptcha(action: "password_reset", minimum_score: 0.5)

      self.resource = resource_class.send_reset_password_instructions(resource_params) if verify_recaptcha_success

      yield resource if block_given?

      if verify_recaptcha_success && successfully_sent?(resource)
        respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
      else
        new_session_path(resource_name)
      end
    end

    protected

    def translation_scope
      "devise.user_passwords"
    end

    private

    def title
      Spree.t(:forgot_password)
    end
  end
end
