#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

class Listener

  def initialize(host: "localhost", port: 5672, queue_name: "gapps", rabbitmq_user: nil, rabbitmq_password: nil, exchange_name: nil, message_handler_map: {default: DefaultMessageHandler})
    @host=host
    @port=port
    @queue_name=queue_name
    @exchange_name=exchange_name
    @rabbitmq_user=rabbitmq_user
    @rabbitmq_password=rabbitmq_password
    @message_handler_map=message_handler_map

  end

  def listen
    conn = Bunny.new(:hostname => @host, :user => @rabbitmq_user, :pass => @rabbitmq_password)
    conn.start

    ch   = conn.create_channel
    x    = ch.topic(@exchange_name, :durable => true)
    q    = ch.queue(@queue_name, :durable => true)

    @message_handler_map.keys.each do |routing_key|
      q.bind(@exchange_name, :routing_key => routing_key)
    end

    puts " [*] Waiting for messages in #{q.name}. To exit press CTRL+C"
    ch.prefetch(1)

    begin
      q.subscribe(:manual_ack => true, :block => true) do |delivery_info, properties, body|
        puts " [#] Received message containing : #{body}"
        routing_key=delivery_info[:routing_key]
        message_handler=@message_handler_map[routing_key]
        message_handler.new(body)
        ch.ack(delivery_info.delivery_tag)
      end
    rescue Interrupt => _
      conn.close
    end
  end

end
