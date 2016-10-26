require './lib/parser'

class Responder

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
