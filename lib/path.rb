require './lib/game'
require 'json'

class Path
  attr_reader :server, :path, :param, :status_code, :game

  def initialize(path, verb, server, param = "", http_accept = "*/*")
    @server = server
    @path = path
    @param = param
    @verb = verb
    @status_code = "200 OK"
    @http_accept = http_accept
  end

  def direct_path
    if path == "/hello"
      hello
    elsif path == '/datetime'
      datetime
    elsif path == '/shutdown'
      shutdown
    elsif path.include?("/word_search")
      word_search
    # elsif @path == "/game_start" && @verb == "POST"
    #   @status_code = "403 Forbidden" if @game == nil
    #   @game = Game.new
    #   server.client.puts @game.start(0)
    #   server.client.puts @game.interface
    #   server.client.puts "<pre>Good luck!</pre>"
    #   @status_code = "301 Moved Permanently"
    # elsif @path == "/game" && @verb == "GET"
    #   # return "You need to start the Game!" if @game.nil?
    #   binding.pry
    #   @game.interface
    #   @status_code = "200 OK"
    # elsif @path == "/game" && @verb == "POST"
    #   # return "You need to start the Game!" if @game.nil?
    #   guess = server.get_post_content
    #   game.start(guess)
    #   @status_code = "301 Moved Permanently"
    elsif path == "/force_error"
      @status_code = "500 Internal Server Error"
      server.client.puts path_error
      server.client.puts "<pre>#{@status_code}</pre>"
    elsif path == "/sleepy"
    else
      @status_code = "404 Not Found"
      "<pre>#{@status_code}</pre>"
    end
  end

  def hello
    server.hello_count += 1
    "<h1>Hello! #{server.hello_count}</h1>"
  end

  def datetime
    time = Time.new
    "<h2>#{time.strftime("%l:%M %p on %A, %d %b %Y")}</h2>"
  end

  def shutdown
    @server.shutdown_count += 1
    "<h2>Total Requests #{server.shutdown_count}</h2>"
  end

  def word_search
    "<h1> WORD SEARCH </h1>"
    if param != ""
      word_search = WordSearch.new
      word_response = word_search.search(@param)
      "<h1>#{word_response}</h1>"
    end
    if http_accept.include?("application/json")
      "<h1>#{@http_accept}</h1>"
    end
  end

  def path_error
    raise 'SystemError'
  rescue => exception
    exception.backtrace.join("\n\t")
  end

  def print_status_code
    server.client.puts "<pre>#{@status_code}</pre>"
  end
end
