require_relative 'test_helper'

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
