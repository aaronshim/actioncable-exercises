require 'websocket-client-simple'
require 'json'

# This library is not advanced enough to let us set the origin
# in the header, but eventually we will hopefully get there

@ws = WebSocket::Client::Simple.connect "ws://localhost:3000/cable"
@cmd = { command: "subscribe", identifier: JSON.dump({ channel: "PostingChannel" }) }
@subscribed = false

def subscribe
  # attempt to subscribe
  @cmd[:command] = "subscribe"
  @ws.send JSON.dump(@cmd)
  puts "Sent subscription request"
  @subscribed = true
end

@ws.on :message do |msg|
  puts "Received: #{msg.data}"
end

@ws.on :open do
  subscribe
end

@ws.on :close do |e|
  "closing with error: #{e}"
  exit 1
end

@ws.on :error do |e|
  "error: #{e}"
end

loop do
  # post what was typed into STDIN
  title = STDIN.gets.strip
  body = STDIN.gets.strip

  subscribe unless @subscribed

  @cmd[:command] = "message"
  @cmd[:data] = JSON.dump({ title: title, body: body, action: "post" })

  @ws.send JSON.dump(@cmd)
end

