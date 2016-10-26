require 'pry'

class Parser
  attr_reader :request_lines

  def initialize(request_lines)
    @request_lines = request_lines
  end

  def parse
    verb = @request_lines[0].split[0]
    path = @request_lines[0].split[1]
    protocol = @request_lines[0].split[2]
    host = @request_lines[1].split(':')[1]
    port = @request_lines[1].split(':')[2]
    origin = @request_lines[1].split(':')[1]
    accept = @request_lines[6].split[1]
    puts "Verb: #{verb}\n"
            path
            "Protocol: #{protocol}\n"
            "Host: #{host}\n"
            "Port: #{port}\n"
            "Origin: #{origin}\n"
            "Accept: #{accept}\n"
  end

  def path
    path = @request_lines[0].split[1]
    "Path: #{path}\n"
    # if path == '/hello_count'
    #   "<h1>Hello! #{hello_count}</h1>"
    # if path == '/datetime'
    # else
    #   path
    # end
  end

end
