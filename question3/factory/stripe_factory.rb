# The stripe factory handles the
# creation of a stripe payment
class StripeFactory
  def payment_method
    StripePayment.new
  end
end
