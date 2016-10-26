require './lib/parser'

class Responder
  attr_reader :request_lines

  # def initialize(request_lines)
  #   @request_lines = request_lines
  # end

  def parse(request_lines)
    parser = Parser.new(request_lines)
    result = parser.parse
    html_wrapper(result)
  end

  def html_wrapper(*args)
    "<html>
    <head></head>
    <body>
    <pre>
      #{args}
    </pre>
    </body>
    </html>"
  end
end
