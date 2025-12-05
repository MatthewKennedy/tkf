Rails.application.routes.draw do
  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to
  # Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the
  # :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being
  # the default of "spree".
  mount Spree::Core::Engine, at: "/"

  Spree::Core::Engine.add_routes do
    scope "(:locale)", locale: /#{Spree.available_locales.join('|')}/, defaults: { locale: nil } do
      devise_for(:user,
        class_name: Spree.user_class.to_s,
        path: :user,
        router_name: :spree
      )
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
  get "/healthz", to: "health_check#show"
end
