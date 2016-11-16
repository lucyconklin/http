require 'socket'
require 'pry'
require 'json'
require './lib/parser'
require './lib/game'
require './lib/word_search'
require './lib/path'

class HttpServer
  attr_reader :tcp_server,
              :client,
              :open,
              :hello_count,
              :shutdown_count,
              :output,
              :parsed_response,
              :status_code,
              :content_length,
              :http_accept

  attr_accessor :hello_count,
                :shutdown_count

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
      @content_length = request_lines[3].split(":")[1].to_i
      http_accept = request_lines[6].split(":")[1].strip
      puts "Got request"
      parser = Parser.new(request_lines)
      @parsed_response = parser.parse
      path = parsed_response["Path: "]
      verb = parsed_response["Verb: "]
      param = parsed_response["Param: "]
        if path == "/game_start" || path == "/game"
          path_response = game_controller(verb, path)
          path_status = status_code
        else
          path_handler = Path.new(path, verb, self, param, http_accept)
          path_response = path_handler.direct_path
          path_status = path_handler.status_code
        end

      formatted_response = format_response(parsed_response)

      puts "Sending response."
      @output = "<html><head></head><body>
                #{path_response}
                <pre>#{formatted_response}</pre><br>
                <pre>#{path_status}</pre>
                </body></html>"
      verb = parsed_response["Verb: "]
      path = parsed_response["Path: "]
      accept = parsed_response["Accept: "]
      get_headers(verb, path)
      client.puts output
      # client.puts get_headers(verb, path)
      puts "Response complete, exiting.\n"
      open_or_close
    end
  end

  def get_headers(verb, path)
    if verb == "POST" && path == "/game_start"
      headers = ["http/1.1 302 Found",
                "location: http://127.0.0.1:9292/game",
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                "server: ruby",
                "content-type: text/html; charset=iso-8859-1",
                "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    elsif verb == "GET" && path == "/game"
      ["http/1.1 302 Found",
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
  end

  def format_response(parsed_response)
    output = parsed_response.map{ |line| line * "" }
    output.join("\n")
  end

  def game_controller(verb, path)
    if path == "/game_start" && verb == "POST"
      @status_code = "403 Forbidden" if @game == nil
      @status_code = "301 Moved Permanently"
      @game = Game.new
      client.puts @game.interface
      client.puts "<pre>Good luck!</pre>"
    elsif path == "/game" && verb == "GET"
      @status_code = "200 OK"
      return "You need to start the Game!" if @game.nil?
      client.puts @game.interface
    else path == "/game" && verb == "POST"
      @status_code = "301 Moved Permanently"
      return "You need to start the Game!" if @game.nil?
      guess = get_post_content
      @game.start(guess)
    end
  end

  def get_post_content
    #pull out content_length from request_lines
    #split on guess and number
    output = @client.read(content_length)
    output.split("=")[1].to_i
  end

  def open_or_close
    if shutdown_count == 12 || hello_count > 11
      tcp_server.close
    else
      client.close
    end
  end
end

server = HttpServer.new
server.start
