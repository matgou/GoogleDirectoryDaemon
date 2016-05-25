#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

class Listener

  def initialize(host: "localhost", port: 5672, queue_name: "gapps", rabbitmq_user: nil, rabbitmq_password: nil, exchange_name: nil, message_handler: DefaultMessageHandler)
    @host=host
    @port=port
    @queue_name=queue_name
    @message_handler=message_handler
    @exchange_name=exchange_name
    @rabbitmq_user=rabbitmq_user
    @rabbitmq_password=rabbitmq_password
  end

  def listen
    conn = Bunny.new(:hostname => @host, :user => @rabbitmq_user, :pass => @rabbitmq_password)
    conn.start


    ch   = conn.create_channel
    if @exchange_name
      x    = ch.direct(@exchange_name)
      q    = ch.queue(@queue_name, :exclusive => true)
      q.bind(@exchange_name, :routing_key => "request.gapps.create")
    else
      q    = ch.queue(@queue_name)
    end

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
