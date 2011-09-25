require 'rubygems'
require 'em-websocket'

puts "Starting Websocket Server..."
print "> "
EM::run do
  @terminal = EM::Channel.new
  @websocket = EM::Channel.new
  @channel = EM::Channel.new
  EM::WebSocket.start(:host => "0.0.0.0", :port => 3080) do |ws|

    ws.onopen do
      sid = @websocket.subscribe{|mes| ws.send mes}

      ws.onclose do
        @websocket.unsubscribe(sid)
      end

      ws.onmessage do |mes|
        @terminal.push mes
        puts mes.gsub(/^/,"   ")
        print "> "
      end


    end
  end
  EM::defer do
    loop do
      mes = gets.to_s.gsub(/[\r\n]/,'')
      next if !mes or mes.size < 1
      @websocket.push mes
    end
  end
end
