#
# payme - A easy way to pay me :)
#
# Payment module - contains all payment related 
# processes & workflows
#
# Gems used,
#  * Highline - For CLI input/output, error
#    checking
#  * Rainbow - CLI colourization
#

# Required libraries
require_relative "payment"
require "highline"
require "rainbow"

module Ux
  
  $cli = HighLine.new

  module_function

  def welcome
    $cli.say("\n|--------------------------------------------------------------------------|")
    $cli.say("|                          #{colour('Welcome to PayMe','yellow')}\
                                |")
    $cli.say("|              A great way to send money to Me   ;)                        |")
    $cli.say("|--------------------------------------------------------------------------|\n\n")
    $cli.say("Please answer the following questions,\n")
  end

  def say(sentence)
    $cli.say(sentence)
  end

  def say_title(title)
    $cli.say(colour("\n------- #{title} -------", 'blue'))
  end

  def ask(question)
    $cli.ask(question)
  end

  def ask_number(question, type, low_value, high_value)
    if(type == Float)
      $cli.ask(question, Float) { |q| q.in = low_value..high_value }
    else
      $cli.ask(question, Integer) { |q| q.in = low_value..high_value }
    end
  end

  def ask_private(question, type)
    $cli.ask("Card CVC: ", type) { |q| q.echo = "*" }
  end

  def colour(text, text_color)
    case text_color
    when 'red'
      return Rainbow(text).red
    when 'blue'
      return Rainbow(text).blue
    when 'green'
      return Rainbow(text).green
    when 'yellow'
      return Rainbow(text).yellow
    else
      text
    end
  end

end
