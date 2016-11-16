require_relative 'test_helper'
require './lib/path'

class PathTest < Minitest::Test
  attr_reader :result

  def setup
    @result = Path.new("/","GET","server")
  end

  def test_path_grabs_path
    assert_equal Path, result.class
    assert_equal "/", result.path
  end

  def test_verb_grabs_verb
    assert_equal "GET", result.verb
  end

  def test_param_defaults_to_empty_string
    assert_equal "", result.param
  end

  def test_http_accept_defaults_to_all
    assert_equal "*/*", result.http_accept
  end

  def test_datetime_gives_datetime
    assert_equal String, result.datetime.class
  end

  def test_path_error_raises_path_error
    assert_equal String, result.path_error.class
  end

  def test_json_response
    result2 = Path.new("/","GET","server","pizz","application/json")
    assert_equal "application/json", result2.http_accept
    assert_equal "{}", result2.word_search
  end
end
