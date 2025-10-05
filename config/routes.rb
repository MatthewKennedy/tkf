Rails.application.routes.draw do
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
