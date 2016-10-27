gem 'minitest'
require './lib/game'
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require 'faraday'

class GameTest < Minitest::Test
  attr_reader :game
  def setup
    @game = Game.new
  end

  def test_game_generates_random_number
    assert @game.random_number
  end

  def test_compare_guess_works
    game.compare(42)
    assert_equal 42, game.guess
  end

  def test_compare_works_for_higher_number
    result = game.compare(99)
    assert_equal "Your guess of 99 was too high", result
  end

  def test_compare_works_for_lower_number
    result = game.compare(1)
    assert_equal "Your guess of 1 was too low", result
  end

  def test_correct_guess
    guess = game.random_number
    result = game.compare(guess)
    assert_equal "Great Job #{guess} was correct and you win!", result
  end

  def test_log_guess_logs_guess
    game.log_guess(9)
    game.log_guess(2)
    game.log_guess(14)
    result = game.guesses
    assert_equal [9, 2, 14], result
  end

  def test_interface_counts_guesses
    game.log_guess(9)
    game.log_guess(2)
    game.log_guess(14)
    result = game.interface

    assert_equal "3 guesses so far.", result
  end

  def test_interface_tells_you_when_no_guesses
    result = game.interface

    assert_equal "no guesses yet", result
  end

end
