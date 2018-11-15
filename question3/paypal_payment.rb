# The paypal payment knows how to execute
# a payment on through paypal
class PaypalPayment < PaymentMethod
  def pay
    puts 'PAID!'
    notify_user('Paypal')
  end
end
