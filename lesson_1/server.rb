require 'socket'

server = TCPServer.new("localhost", 3003)

loop do
  client = server.accept

  request_line = client.gets
  response = "HTTP/1.1 200 OK\r\n\r\n"
  response << "Content-Type: text/html\r\n\r\n"
  response << request_line
  response << "<h1 color='red'>Your random dice roll is #{rand(0..6)}.</h1>"

  client.puts response
  client.close
end
