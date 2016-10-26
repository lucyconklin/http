gem 'minitest'
require './lib/parser'
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require 'faraday'

class ParserTest < Minitest::Test

  def setup
    parser = Parser.new(request_lines)
  end

  def test_path_returns_path
    result = parser.path
    assert_equal , "/"
  end
end
