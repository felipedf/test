class PaymentFactory
  def process_payment
    payment_method.pay!
  end

  def payment_method
    raise "method #payment_method must be defined"
  end
end
