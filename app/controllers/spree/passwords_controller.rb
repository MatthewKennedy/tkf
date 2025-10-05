module Spree
  class PasswordsController < ::Devise::PasswordsController
    include Spree::Storefront::DeviseConcern

     # POST /resource/password
     def create
       self.resource = resource_class.send_reset_password_instructions(resource_params)
       yield resource if block_given?

       if verify_recaptcha(action: "signup", minimum_score: 0.5) && successfully_sent?(resource)
         respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
       else
         respond_with(resource)
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
