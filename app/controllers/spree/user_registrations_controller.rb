module Spree
  class UserRegistrationsController < ::Devise::RegistrationsController
    include Spree::Storefront::DeviseConcern

    def create
      Rails.logger.info("recaptcha: #{verify_recaptcha(action: 'signup', minimum_score: 0.5)}")

      super
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
