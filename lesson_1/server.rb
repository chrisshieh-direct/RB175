require 'socket'

def parse_request(request_line)
  http_method, path_and_params, http = request_line.split(" ")
  path, params = path_and_params.split("?")
  params = params.split("&").map { |x| x.split("=") }.each_with_object({}) do |x, hash|
    hash[x[0]] = x[1]
  end
  [http_method, path, params]
end

server = TCPServer.new("localhost", 3003)

loop do
  client = server.accept

  request_line = client.gets
  next if !request_line || request_line =~ /favicon/

  response = "<html><head></head><body><h1>Welcome to the dice rolling page!</h1>"
  response << "<h2>Let's roll some dice.</h2>"

  http_method, path, params = parse_request(request_line)

  rolls = params["rolls"].to_i
  sides = params["sides"].to_i
  total = 0

  1.upto(rolls) do |x|
    response << "<p>Rolling a die with #{sides} sides: #{roll = rand(1..sides)}</p>"
    total += roll
  end

  response << "<h2 style='color: red'>The total is #{total}.</h3>"
  response << "</body></html>"

  client.puts "HTTP/1.1 200 OK"
  client.puts "Content-Type: text/html"
  client.puts
  client.puts response

  client.close
end
