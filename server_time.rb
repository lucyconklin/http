require "socket"
require 'json'
require 'faraday'
require 'pry'

url = "localhost:9292"
# binding.pry
res = Faraday.new(url)
binding.pry

puts res.status
