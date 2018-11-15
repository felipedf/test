# The paypal factory handles the
# creation of a paypal payment
class PaypalFactory
  def payment_method
    PaypalPayment.new
  end
end
