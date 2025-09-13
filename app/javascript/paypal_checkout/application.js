import '@hotwired/turbo-rails'
import { Application } from '@hotwired/stimulus'

let application

if (typeof window.Stimulus === "undefined") {
  application = Application.start()
  application.debug = false
  window.Stimulus = application
} else {
  application = window.Stimulus
}

import CheckoutPaypalController from 'paypal_checkout/controllers/paypal_controller'

application.register('checkout-paypal', CheckoutPaypalController)
