class HeaderGenerator
  attr_reader :verb, :path, :output_length

  def initialize(verb, path, length)
    @verb          = verb
    @path          = path
    @output_length = length
  end

  def get_headers
    if @verb == "POST" && @path == "/game_start"
      headers = ["http/1.1 302 Found",
                "location: http://127.0.0.1:9292/game",
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                "server: ruby",
                "content-type: text/html; charset=iso-8859-1",
                "content-length: #{@output_length}\r\n\r\n"].join("\r\n")
    elsif @verb == "GET" && @path == "/game"
      ["http/1.1 302 Found",
                "location: http://127.0.0.1:9292/game",
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                "server: ruby",
                "content-type: text/html; charset=iso-8859-1",
                "content-length: #{@output_length}\r\n\r\n"].join("\r\n")
    elsif @path == "/word_search"
      headers = ["http/1.1 200 ok",
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                "server: ruby",
                "content-type: text/html; charset=iso-8859-1",
                "content-length: #{@output_length}\r\n\r\n"].join("\r\n")
    else
      headers = ["http/1.1 200 ok",
                "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
                "server: ruby",
                "content-type: text/html; charset=iso-8859-1",
                "content-length: #{@output_length}\r\n\r\n"].join("\r\n")
    end
  end

end
