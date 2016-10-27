require 'socket'
require 'pry'
require './lib/parser'
require './lib/responder'
require './lib/game'
require './lib/word_search'

class HttpServer
  attr_reader :tcp_server, :client, :open, :hello_count, :shutdown_count, :output, :parsed_response

  def initialize
    @tcp_server = TCPServer.new(9292)
    @open = true
    @hello_count = 0
    @shutdown_count = 0
    @output
    @parsed_response
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
      @parsed_response = parser.parse
      path_response = check_path(parsed_response["Path: "])

      word_response = ""
      if parsed_response["Param: "]
        word_search = WordSearch.new
        word_response = word_search.search(parsed_response["Param: "])
      end
      # binding.pry

      if parsed_response["Path: "] == "/game_start"
        @parsed_response["Verb: "] = "POST"
      end

      formatted_response = parsed_response.to_a.join("<br>")


      puts "Sending response."
      @output = "<html><head></head><body>" + "<h1>#{word_response}</h1>"+ "#{path_response}" + "<pre>" "#{formatted_response}" + "</pre>" + "</body></html>"

      verb = parsed_response["Verb: "]
      path = parsed_response["Path: "]
      # binding.pry
      get_headers(verb, path)
      client.puts output

      puts "\nResponse complete, exiting."
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

  def get_headers(verb, path)
    if verb == "POST" && path == "/game"
      headers = ["http/1.1 302 Found",
                "location: http://127.0.0.1:9292/game",
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                "server: ruby",
                "content-type: text/html; charset=iso-8859-1",
                "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    else
      headers = ["http/1.1 200 ok",
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                "server: ruby",
                "content-type: text/html; charset=iso-8859-1",
                "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    end
    client.puts headers
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
    elsif path == "/kitten"
      "<img src = 'http://placekitten.com/500/500'>"
    elsif path == "/god"

    elsif path.include?("/word_search")
      "<h1> WORD SEARCH </h1>"
    elsif path == "/game_start"
      client.puts "<pre>Good luck!</pre>"
      game = Game.new
      game.start

    elsif path == "/game"
      #continue the game
    else
      "something else"
    end
  end
end

server = HttpServer.new
server.start
