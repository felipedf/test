class StripeFactory < PaymentFactory
  def payment_method
    StripePayment.new
  end
end
