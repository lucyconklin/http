require 'pry'

class Parser
  attr_reader :request_lines,
              :hello_count

  def initialize(request_lines)
    @request_lines = request_lines
    @hello_count = 0
  end

  def parse
    hash = create_hash(request_lines)
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
    if path.include?("/word_search")
      accept = "application/json"
    else
      accept = @request_lines[6].split[1]
    end
    lines["Accept: "] = accept
    if request_lines[0].split(' ')[1].include?('?')
      param = request_lines[0].split(' ')[1].split('?')[1].split('=')[1]
    end
    lines["Param: "] = param
    return lines
  end

end
