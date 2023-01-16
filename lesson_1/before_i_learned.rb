require 'socket'

server = TCPServer.new("localhost", 3003)

loop do
  client = server.accept

  request_line = client.gets
  response = "HTTP/1.1 200 OK\r\n\r\n"
  response << "Content-Type: text/plain\r\n\r\n"
  response << request_line
  response << "Let's roll some dice.\r\n\r\n"

  params_string = request_line.scan(/\S*\S/)[1]
  params_string = params_string[2..].split('&').map { |x| x.split('=') }
  params = {}
  params_string.each do |k, v|
    params[k] = v
  end
  client.puts response
  client.puts "Rolling #{params['rolls']} dice, each one has #{params['sides']} sides.\r\n\r\n"
  total = 0
  roll = 0
  params['rolls'].to_i.times do |x|
    client.puts "#{x + 1}. Rolls a #{roll = rand(1..params['sides'].to_i)}."
    total += roll
  end
  client.puts "The total is #{total}."
  client.close
end
