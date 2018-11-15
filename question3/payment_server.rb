class PaymentServer
  def initialize(payment_type)
    # The type of payment desired is passed in
    # and set here. We are varying
    # the behavior responsible for
    # a payment.
    @payment_type = payment_type
  end

  # In the #process_payment! method, we are calling the
  # #pay! method of the factory that has been passed in upon
  # initialization. This PaymentServer class
  # does not have to know what type of payment
  # is being used, but it can be confident that the payment_type
  # will know how to handle its payment
  def process_payment!
    @payment_type.pay
  end
end
