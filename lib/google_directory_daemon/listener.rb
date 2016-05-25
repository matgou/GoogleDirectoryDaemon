#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

class Listener

  def initialize(host: "localhost", port: 5672, queue_name: "gapps", message_handler: DefaultMessageHandler)
    @host=host
    @port=port
    @queue_name=queue_name
    @message_handler=message_handler
  end

  def listen
    conn = Bunny.new(:hostname => "localhost")
    conn.start

    ch   = conn.create_channel
    q    = ch.queue(@queue_name)

    puts " [*] Waiting for messages in #{q.name}. To exit press CTRL+C"
    ch.prefetch(1)

    begin
      q.subscribe(:manual_ack => true, :block => true) do |delivery_info, properties, body|
        puts " [x] Received request for #{body}"
        @message_handler.new(body)
        ch.ack(delivery_info.delivery_tag)
      end
    rescue Interrupt => _
      conn.close
    end
  end

end