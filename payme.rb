#
# payme - A easy way to pay me :)
#  

# Required libraries
require_relative "payment"
require_relative "ux"

# Main 
Ux.welcome
Ux.say_title('Money')
amount = Ux.ask_number("How much would you like to Pay (USD): ", Float,
                        Payment::AMOUNT_MIN, Payment::AMOUNT_MAX)

Ux.say_title("Personal Info")
name = Ux.ask("Your full name: ")
email = Ux.ask("Your email address: ")

Ux.say_title("Payment Info")
cc_number = Ux.ask("Credit/Debit Card number: ").delete(' ')
cc_exp_month = Ux.ask_number("Card expiry month: ", Integer,
                             Payment::MONTH_MIN, Payment::MONTH_MAX)
cc_exp_year = Ux.ask_number("Card expiry year: ", Integer,
                             Payment::YEAR_MIN, Payment::YEAR_MAX)
cc_cvc = Ux.ask_private("Card CVC: ", Integer) { |q| q.echo = "*" }

Ux.say_title('Verifying')
if(Payment.card_valid?(cc_number))
  Ux.say("Your card is #{Ux.colour("valid",'green')} (#{Payment.card_brand_name(cc_number)})")
  Ux.say_title('Transaction')
  Ux.say("Running transaction")
  tok = Payment.create_token(cc_number, cc_exp_month, cc_exp_year, cc_cvc)
  charge = Payment.charge(amount, Payment::CURRENCY_DEFAULT, tok)
  Ux.say("Transaction successful")
  Ux.say("Thankyou for sending Saad $#{amount}")
  Payment.send_email(name, email, amount)
  Ux.say("We have just emailed you a receipt at #{email}")
  Ux.say('Bye')
else
  Ux.say("Your card is #{Ux.colour("not valid",'red')} ... Exiting ...")
end