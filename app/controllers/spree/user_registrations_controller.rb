module Spree
  class UserRegistrationsController < ::Devise::RegistrationsController
    include Spree::Storefront::DeviseConcern

    def create
      Rails.logger.info("recaptcha: #{verify_recaptcha(action: 'signup', minimum_score: 0.5)}")

      super
    end

    # POST /resource
      def create
        build_resource(sign_up_params)

        verify_recaptcha(action: 'signup', minimum_score: 0.5) && resource.save

        yield resource if block_given?
        if resource.persisted?
          if resource.active_for_authentication?
            set_flash_message! :notice, :signed_up
            sign_up(resource_name, resource)
            respond_with resource, location: after_sign_up_path_for(resource)
          else
            set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
            expire_data_after_sign_in!
            respond_with resource, location: after_inactive_sign_up_path_for(resource)
          end
        else
          clean_up_passwords resource
          set_minimum_password_length
          set_flash_message! :notice, :failed_attempt
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      end

    protected

    def translation_scope
      "devise.user_registrations"
    end

    private

    def title
      Spree.t(:sign_up)
    end
  end
end
