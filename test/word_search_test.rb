gem 'minitest'
require './lib/word_search'
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require 'faraday'

class WordSearchTest < Minitest::Test
  attr_reader :word_search
  def setup
    @word_search =  WordSearch.new
  end

  def test_can_load_dictionary
    result = word_search.load_dictionary
    assert_equal true, result["aa"]
  end

  def test_can_test_an_existing_word
    result = word_search.search("bear")
    assert_equal "bear is a known word", result
  end
end
