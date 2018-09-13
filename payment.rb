#
# payme - A easy way to pay me :)
#
# Payment module - contains all payment related 
# processes & workflows
#
# Gems used,
#  * Credit card validation - for algorithmic 
#    verification of credit card numbers
#
# Third party services used,
#  * Stripe - for payment processing
#  * MailGun - for transactional email 
#

# Required libraries
require 'credit_card_validations'
require 'mailgun'
require 'stripe'

module Payment

  # Add your Stripe private key here (or even better
  # set it as an Environment variable and access it 
  # as required)
  Stripe.api_key = ""

  #Constants
  AMOUNT_MIN = 0.00
  AMOUNT_MAX = 9999.00

  MONTH_MIN = 0
  MONTH_MAX = 12

  YEAR_MIN = 2018
  YEAR_MAX = 2050

  CURRENCY_DEFAULT = 'usd'

  # Functions

  module_function

  def card_brand_name(card_number)
    detector = CreditCardValidations::Detector.new(card_number)
    detector.brand
  end

  def card_valid?(card_number)
    detector = CreditCardValidations::Detector.new(card_number)
    detector.valid?
  end

  def create_token(card_number, card_exp_month, card_exp_year, card_cvc)
    tok = Stripe::Token.create(
      :card => {
        :number => card_number,
        :exp_month => card_exp_month,
        :exp_year => card_exp_year,
        :cvc => card_cvc
      },
    )
  end

  def charge(amount, currency, tok)
    
    charge = Stripe::Charge.create(
      :amount => (amount*100).to_i,
      :currency => currency,
      :source => tok,
      :description => "payme to Me :) Thank you"
    )
  end

  # Update with your Mailgun API key and email details
  def send_email(name, email, amount)
    mg_client = Mailgun::Client.new #'Your Mailgun API key'
    message_params =  { from: 'me@me',
                    to:   email,
                    subject: 'Payme: Thanks',
                    text:    "Hi #{name},\nThanks for sending Me a payment of $#{amount}"
                  }

    mg_client.send_message 'mail.fun', message_params
  end
end