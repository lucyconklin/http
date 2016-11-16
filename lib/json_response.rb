require 'json'
require './lib/word_search'

class JSONResponse
  attr_reader :word_search

  def initialize(param, word_search)
    @word_search = word_search
    @param = param
  end

  def parse
    is_word = word_search.is_word?(@param)
    possible_matches = word_search.possible_matches(@param)
    hash = {"word"=> @param, "is_word"=>is_word, "possible_matches"=>possible_matches}
    JSON.generate(hash)
  end
end
