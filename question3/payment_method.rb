# The payment method handles a few common
# methods among all payments types.
class PaymentMethod
  # Any method that is common to the whole payment process
  def notify_user(type)
    puts "Paid with #{type}"
  end

  def pay!
    raise "Must implement #pay! method on its subclasses"
  end
end