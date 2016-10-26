require 'pry'

class Parser
  attr_reader :request_lines, :hello_count

  def initialize(request_lines)
    @request_lines = request_lines
    @hello_count = 0
  end

  def parse
    # verb = @request_lines[0].split[0]
    # path = @request_lines[0].split[1]
    # protocol = @request_lines[0].split[2]
    # host = @request_lines[1].split(':')[1]
    # port = @request_lines[1].split(':')[2]
    # origin = @request_lines[1].split(':')[1]
    # accept = @request_lines[6].split[1]
    # "Verb: #{verb}\n
    # Path: #{path}\n
    # Protocol: #{protocol}\n
    # Host: #{host}\n
    # Port: #{port}\n
    # Origin: #{origin}\n
    # Accept: #{accept}\n"
    hash = create_hash(request_lines)
    return hash
  end

  def create_hash(request_lines)
    lines = Hash.new
    verb = @request_lines[0].split[0]
    lines["Verb: "] = verb
    path = @request_lines[0].split[1]
    lines["Path: "] = path
    protocol = @request_lines[0].split[2]
    lines["Protocol: "] = protocol
    host = @request_lines[1].split(':')[1]
    lines["Host: "] = host
    port = @request_lines[1].split(':')[2]
    lines["Port: "] = port
    origin = @request_lines[1].split(':')[1]
    lines["Origin: "] = origin
    accept = @request_lines[6].split[1]
    lines["Accept: "] = accept
    return lines
  end
  #
  # def check_path
  #   path = @request_lines[0].split[1]
  #   if path == "/hello"
  #     "<h1>Hello! #{hello_count}</h1>"
  #     # hello_count += 1
  #   elsif path == '/datetime'
  #     puts ""
  #   elsif path == '/shutdown'
  #   #   path
  #   end
  # end

end
