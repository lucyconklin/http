require 'socket'
require 'pry'
# require './lib/server'

class Game
attr_reader :guess, :guesses, :random_number

  def initialize
    @random_number = 0
    random_number
    @guesses = []
    @guess = 0
  end

  def start

  end

  def random_number
    array = [*0..100]
    array = array.shuffle
    @random_number = array.pop
  end

  def compare(guess)
    @guess = guess
    if guess > 100 || guess < 0
      return 'Try again, not in range'
    elsif guess < @random_number
      return "Your guess of #{guess} was too low"
    elsif guess > @random_number
      return "Your guess of #{guess} was too high"
    elsif guess == @random_number
      return "Great Job #{guess} was correct and you win!"
    end
    log_guess(@guess)
  end

  def log_guess(guess)
    @guesses << guess
  end

  def interface
    if guesses.length == 0
      return "no guesses yet"
    end
    "#{guesses.length} guesses so far."
  end

end
