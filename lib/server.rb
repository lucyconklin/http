require 'socket'
require 'pry'
require './lib/parser'
require './lib/responder'

class HttpServer
  attr_reader :tcp_server, :client, :open, :hello_count, :shutdown_count

  def initialize
    @tcp_server = TCPServer.new(9292)
    @open = true
    @hello_count = 0
    @shutdown_count = 0
  end

  def start
    puts "Ready for a request"

    count = 0
    loop do
      @client = tcp_server.accept
      request_lines = []
      while line = client.gets and !line.chomp.empty?
        request_lines << line.chomp
      end

      puts "Got this request:"
      parser = Parser.new(request_lines)
      response = parser.parse
      path_response = check_path(response["Path: "])

      puts "Sending response."
      # response = "<pre>" + request_lines.join("\n") + "</pre>"
      output = "#{path_response}" + "<pre>" + "#{response}" + "</pre>"
      headers = ["http/1.1 200 ok",
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                "server: ruby",
                "content-type: text/html; charset=iso-8859-1",
                "content-length: #{output.length}\r\n\r\n"].join("\r\n")
      client.puts headers
      client.puts output

      # puts ["Wrote this response:", headers, output].join("\n")

      puts "\nResponse complete, exiting."
      # hello_count += 1
      count += 1
      if @shutdown_count == 12
        tcp_server.close
      end
      if count > 20
        tcp_server.close
      else
        client.close
      end

    end
  end

  def check_path(path)
    if path == "/hello"
      @hello_count += 1
      "<h1>Hello! #{hello_count}</h1>"
    elsif path == '/datetime'
      time = Time.new
      "<h2>#{time.strftime("%l:%M %p on %A, %d %b %Y")}</h2>"
    elsif path == '/shutdown'
      @shutdown_count += 1
      "<h2>Total Requests #{shutdown_count}</h2>"
    elsif "/kitten"
      # "<img src = 'http://placekitten.com/500/500'>"
    elsif "/word_search"
      "<h1>WORD SEARCH</h1>"
    else
      ""
    end
  end
end

server = HttpServer.new
server.start
