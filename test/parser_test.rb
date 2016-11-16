require_relative 'test_helper'
require_relative '../lib/parser'

class ParserTest < Minitest::Test
  attr_reader :request_lines, :word_search_request_lines
  def setup
      @request_lines = ["GET / HTTP/1.1",
                        "Host: 127.0.0.1:9292",
                        "Connection: keep-alive",
                        "Cache-Control: no-cache",
                        "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36",
                        "Postman-Token: 99b90230-af03-27b3-9bd8-276a1bc5c66b",
                        "Accept: */*",
                        "Accept-Encoding: gzip, deflate, sdch, br",
                        "Accept-Language: en-US,en;q=0.8"]

     @word_search_request_lines = ["GET /word_search HTTP/1.1",
                                  "Host: 127.0.0.1:9292",
                                  "Connection: keep-alive",
                                  "Cache-Control: no-cache",
                                  "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36",
                                  "Postman-Token: 99b90230-af03-27b3-9bd8-276a1bc5c66b",
                                  "Accept: */*",
                                  "Accept-Encoding: gzip, deflate, sdch, br",
                                  "Accept-Language: en-US,en;q=0.8"]
  end

  def test_parse_returns_hash
    parser = Parser.new(@request_lines)
    result = parser.parse
    assert_equal Hash, result.class
  end

  def test_verb_returns_verb
    parser = Parser.new(@request_lines)
    result = parser.parse
    assert_equal "GET", result["Verb: "]
  end

  def test_path_returns_path
    parser = Parser.new(@request_lines)
    result = parser.parse
    assert_equal "/", result["Path: "]
  end

  def test_protocol_returns_protocol
    parser = Parser.new(@request_lines)
    result = parser.parse
    assert_equal "HTTP/1.1", result["Protocol: "]
  end

  def test_host_returns_host
    parser = Parser.new(@request_lines)
    result = parser.parse
    assert_equal " 127.0.0.1", result["Host: "]
  end

  def test_port_returns_port
    parser = Parser.new(@request_lines)
    result = parser.parse
    assert_equal "9292", result["Port: "]
  end

  def test_accept_returns_accept
    parser = Parser.new(@request_lines)
    result = parser.parse
    assert_equal "*/*", result["Accept: "]
  end
  
  def test_word_seach_accepts_json
    parser = Parser.new(@word_search_request_lines)
    result = parser.parse
    assert_equal "application/json", result["Accept: "]
  end
end
