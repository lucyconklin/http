require_relative 'test_helper'
require './lib/json_response'

class HeaderGeneratorTest < Minitest::Test
  attr_reader :result

  def setup
    @result = JSONResponse.new("pizz", WordSearch.new)
  end

  def test_initialize_works
    assert_equal JSONResponse, result.class
    assert_equal String, result.parse.class
  end

  def test_possible_matches
    possible_matches = result.word_search.possible_matches("pizz")
    assert_equal Array, possible_matches.class
    assert_equal ["pizza", "pizzeria", "pizzicato", "pizzle", "spizzerinctum"], possible_matches
  end

  def test_is_word_method
    is_word = result.word_search.is_word?("aa")
    assert_equal true, is_word
  end
end
