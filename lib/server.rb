require 'socket'
require 'pry'
require 'json'
require './lib/parser'
require './lib/game'
require './lib/word_search'
require './lib/path'
require './lib/header_generator'

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
    loop do
      @client = tcp_server.accept
      request_lines = []
      while line = client.gets and !line.chomp.empty?
        request_lines << line.chomp
      end
      puts "Got request"
      @content_length = request_lines[3].split(":")[1].to_i
      @parsed_response = Parser.new(request_lines).parse
      path = parsed_response["Path: "]
      verb = parsed_response["Verb: "]
      http_accept = parsed_response["Accept: "]
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
                #{path_response}<pre>#{formatted_response}</pre>
                <br><pre>#{path_status}</pre></body></html>"
      headers = HeaderGenerator.new(verb, path, output.length)
      client.puts output
      puts "Response complete, exiting.\n"
      open_or_close
    end
  end

  def format_response(parsed_response)
    output = parsed_response.map{ |line| line * "" }
    output.join("\n")
  end

  def game_controller(verb, path)
    if path == "/game_start" && verb == "POST"
      start_game
    elsif path == "/game" && verb == "GET"
      game_status
    else path == "/game" && verb == "POST"
      game_submit_guess
    end
  end

  def start_game
    @status_code = "403 Forbidden" if @game == nil
    @status_code = "301 Moved Permanently"
    @game = Game.new
    client.puts @game.interface
    client.puts "<pre>Good luck!</pre>"
  end

  def game_status
    @status_code = "200 OK"
    return "You need to start the Game!" if @game.nil?
    client.puts @game.interface
  end

  def game_submit_guess
    @status_code = "301 Moved Permanently"
    return "You need to start the Game!" if @game.nil?
    @game.start(get_post_content)
  end

  def get_post_content
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
