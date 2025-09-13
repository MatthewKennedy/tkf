# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"


# pin "paypal-checkout", to: "paypal_checkout/application.js", preload: false
# pin_all_from "app/javascript/paypal_checkout/controllers", under: "paypal_checkout/controllers", to: "paypal_checkout/controllers", preload: "paypal-checkout"


# PayPal area (separate Stimulus app or bundle)
pin "@paypal/paypal-js", to: "@paypal--paypal-js.js" # @8.3.0
pin "paypal-checkout", to: "paypal_checkout/application.js", preload: false
pin_all_from "app/javascript/paypal_checkout/controllers", under: "paypal_checkout/controllers"
