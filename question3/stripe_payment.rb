# The stripe payment knows how to execute
# a payment on through stripe
class StripePayment < PaymentMethod
  def pay
    puts 'PAID!'
    notify_user('Stripe')
  end
end
