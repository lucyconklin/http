require 'socket'
require 'pry'
# require './lib/server'

class WordSearch
  attr_reader :dictionary

  def initialize
    # @dictionary = load_dictionary
  end

  def load_dictionary
    dictionary = {}
    File.open("/usr/share/dict/words") do |file|
      file.each do |line|
      dictionary[line.strip] = true
      end
    end
    dictionary
  end

  def search(param)  
    dictionary = load_dictionary
    if dictionary[param.downcase]
      result = "#{param} is a known word"
    else
      result = "#{param} is not a known word"
    end
    result
  end

end
