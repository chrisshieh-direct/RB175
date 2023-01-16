require 'socket'

def parse_request(request_line)
  http_method, path_and_params, http = request_line.split(" ")
  path, params = path_and_params.split("?")

  params = (params || "").split("&").each_with_object({}) do |x, hash|
    key, value = x.split('=')
    hash[key] = value
  end

  [http_method, path, params]
end

server = TCPServer.new("localhost", 3003)

loop do
  client = server.accept

  request_line = client.gets
  next if !request_line || request_line =~ /favicon/


  http_method, path, params = parse_request(request_line)

  response = "<html><head></head><body><h1>Welcome to the fancy COUNTER!</h1>"
  response << "<h2>The counter is #{params['number'].to_i}.<h2>"
  response << "<h3><a href='/?number=#{params['number'].to_i + 1}'>Add one</a></h3>"
  response << "<h3><a href='/?number=#{params['number'].to_i - 1}'>Subtract one</a></h3>"

  client.puts "HTTP/1.1 200 OK"
  client.puts "Content-Type: text/html"
  client.puts
  client.puts response

  client.close
end
