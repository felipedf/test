%w[payment_method
   payment_server
   factory/paypal_factory
   factory/stripe_factory
   paypal_payment
   stripe_payment].each { |klass| require_relative klass }


paypal = PaypalFactory.new.payment_method
payment = PaymentServer.new(paypal)
payment.process_payment!

stripe = StripeFactory.new.payment_method
payment = PaymentServer.new(stripe)
payment.process_payment!
