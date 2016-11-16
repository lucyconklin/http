require_relative 'test_helper'
require './lib/header_generator'

class HeaderGeneratorTest < Minitest::Test

  def test_it_takes_three_initial_variables
    result = HeaderGenerator.new("GET", "/", 0)
    assert_equal HeaderGenerator, result.class
    assert_equal "/", result.path
    assert_equal "GET", result.verb
    assert_equal 0, result.output_length
  end
end
