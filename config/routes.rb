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
    # Admin authentication
    devise_for(
      Spree.admin_user_class.model_name.singular_route_key,
      class_name: Spree.admin_user_class.to_s,
      controllers: {
        sessions: "spree/admin/user_sessions",
        passwords: "spree/admin/user_passwords"
      },
      skip: :registrations,
      path: :admin_user,
      router_name: :spree
    )
  end
  Spree::Core::Engine.add_routes do
    # Storefront routes
    scope "(:locale)", locale: /#{Spree.available_locales.join('|')}/, defaults: { locale: nil } do
      devise_for(
        Spree.user_class.model_name.singular_route_key,
        class_name: Spree.user_class.to_s,
        path: :user,
        controllers: {
          sessions: "spree/user_sessions",
          passwords: "spree/user_passwords",
          registrations: "spree/user_registrations"
        },
        router_name: :spree
      )
    end
  end
  devise_for :admin_users, class_name: "Spree::AdminUser"
  devise_for :users, class_name: "Spree::User"

  get "up" => "rails/health#show", as: :rails_health_check
  get "/healthz", to: "health_check#show"
end
