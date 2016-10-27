gem 'minitest'
# require './lib/server'
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require 'faraday'

class ServerTest < Minitest::Test

 def test_server_can_listen
   response = Faraday.get("http://localhost:9292")
   assert_equal 200, response.status
 end

 def test_server_returns_hello_world_count
   response = Faraday.get("http://localhost:9292/hello")
   assert_equal 200, response.body
 end
end
