require 'socket'
require 'pry'
require './lib/parser'
require './lib/responder'

class HttpServer
  attr_reader :tcp_server, :client, :open, :hello_count

  def initialize
    @tcp_server = TCPServer.new(9292)
    @client = tcp_server.accept
    @open = true
  end

  def start
    hello_count = 0
    while @open == true
      puts "Ready for a request"
      request_lines = []
      while line = client.gets and !line.chomp.empty?
        request_lines << line.chomp
      end

      puts "Got this request:"
      response = Responder.new
      response.parse(request_lines)

      puts "Sending response."
      # response = "<pre>" + request_lines.join("\n") + "</pre>"
      # output = "<html><head></head><body>#{parser.parse}</body></html>"
      # headers = ["http/1.1 200 ok",
      #           "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      #           "server: ruby",
      #           "content-type: text/html; charset=iso-8859-1",
      #           "content-length: #{output.length}\r\n\r\n"].join("\r\n")
      # client.puts headers
      # client.puts output

      # puts ["Wrote this response:", headers, output].join("\n")

      puts "\nResponse complete, exiting."
      hello_count += 1
      if hello_count == 4
        client.close
      end

    end
  end
end

server = HttpServer.new
server.start
