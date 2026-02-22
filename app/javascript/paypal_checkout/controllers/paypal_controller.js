import { Controller } from '@hotwired/stimulus'
import showFlashMessage from 'spree/storefront/helpers/show_flash_message'
import { post, put } from '@rails/request.js'
import { loadScript } from "@paypal/paypal-js"

export default class extends Controller {
  static values = {
    // SDK
    clientId: String,
    clientKey: String,
    currency: String,
    components: { type: String, default: 'buttons' },

    // Order context
    orderNumber: String,
    orderToken: String,
    amount: Number,

    // API endpoints
    apiCreateOrderPath: String,
    apiCaptureOrderPath: String,
    apiCheckoutUpdatePath: String,
    returnUrl: String,
  }
  static targets = ["buttonContainer"]

  connect() {
    this.submitTarget = document.querySelector('#checkout-payment-submit')
    this.submitTarget.style.display = 'none'
    this.initPayPal();
  }

  disconnect() {
    this.submitTarget.style.display = 'block'
  }

  async initPayPal() {
    try {
      const paypal = await loadScript({
        "client-id": this.clientIdValue,
        currency: this.currencyValue,
        components: this.componentsValue,
      });

      paypal.Buttons({
        style: {
          shape: "rect",
          layout: "vertical",
          color: "gold",
          label: "paypal",
        },
        createOrder: async () => {
          const response = await post(this.apiCreateOrderPathValue, {
            headers: {
              "X-Spree-Order-Token": this.orderTokenValue,
            }
          });

          if (response.ok) {
            const paypalOrder = await response.json();

            if (!paypalOrder.data) {
              throw new Error(paypalOrder.error || 'Failed to create PayPal order');
            }

            const orderId = paypalOrder.data.attributes.paypal_id;

            if (!orderId) {
              throw new Error('No PayPal order ID found in response');
            }

            return String(orderId);
          } else {
            showFlashMessage('error', `Sorry, your transaction could not be processed. Please try again.`);
            throw new Error('Failed to create PayPal order');
          }
        },
        onApprove: async (data, actions) => {
          const response = await put(
            this.apiCaptureOrderPathValue.replace(this.orderNumberValue, data.orderID),
            {
              headers: {
                "X-Spree-Order-Token": this.orderTokenValue,
              },
            }
          );

          if (response.ok) {
            window.location.href = this.returnUrlValue;
          } else {
            showFlashMessage('error', `Sorry, your transaction could not be processed. Please try again.`);
          }
        },
        onError: (err) => {
          showFlashMessage('error', `Your transaction was cancelled...<br><br>${err}`);
        }
      }).render(this.buttonContainerTarget);
    } catch (error) {
      this.element.innerHTML = "<p>Could not load payment options. Please try again later.</p>";
    }
  }
}
