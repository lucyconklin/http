gem 'minitest'
require './lib/server'
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require 'faraday'

class ServerTest < Minitest::Test

  def setup
    server = Faraday.get('http://127.0.0.1:9292/')
  end

  def test_server_listens_to_port
  end

  def test_server_keeps_track_of_requests
  end

  def test_200_status
    assert_equal 200, server.status
  end
end
