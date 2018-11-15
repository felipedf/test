class PaypalFactory < PaymentFactory
  def payment_method
    PaypalPayment.new
  end
end
