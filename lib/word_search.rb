require 'socket'
require 'pry'
# require './lib/server'

class WordSearch
  attr_reader :dictionary

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

  def possible_matches(param)
    dictionary = load_dictionary
    dictionary.keys.select do |word|
      word.include?(param.downcase)
    end
  end

  def is_word?(param)
    dictionary = load_dictionary
    if dictionary[param.downcase]
      true
    else
      false
    end
  end

end
