#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

class Listener

  def initialize(host: "localhost", port: 5672, queue_name: "gapps", rabbitmq_user: nil, rabbitmq_password: nil, exchange_name: nil, message_handler_map: {default: DefaultMessageHandler}, deferred_time: 1800000)
    @host=host
    @port=port
    @queue_name=queue_name
    @exchange_name=exchange_name
    @rabbitmq_user=rabbitmq_user
    @rabbitmq_password=rabbitmq_password
    @message_handler_map=message_handler_map
    @deferred_time=deferred_time

  end

  def listen
    conn = rmq_connection

    ch   = conn.create_channel
    x    = ch.topic(@exchange_name)
    q    = ch.queue(@queue_name, :exclusive => true)

    @message_handler_map.keys.each do |routing_key|
      q.bind(@exchange_name, :routing_key => routing_key)
    end

    q.bind(@exchange_name, :routing_key => '#')

    puts " [*] Waiting for messages in #{q.name}. To exit press CTRL+C"
    ch.prefetch(1)

    begin
      q.subscribe(:manual_ack => true, :block => true) do |delivery_info, properties, body|
        routing_key=delivery_info[:routing_key]
        puts " [#] Received message with routing key #{routing_key} containing : #{body}"
        message_handler=@message_handler_map[routing_key]
        message_handler.new(body)
        ch.ack(delivery_info.delivery_tag)
        send_to_deferred_queue(body,routing_key)


      end
    rescue Interrupt => _
      conn.close
    end
  end

  def rmq_connection
      if @rmq_connection
        @rmq_connection
      else
        @rmq_connection=Bunny.new(:hostname => @host, :user => @rabbitmq_user, :pass => @rabbitmq_password)
        @rmq_connection.start
        @rmq_connection
      end
  end

  def send_to_deferred_queue(msg,routing_key)
    conn=rmq_connection
    @delayed_chan||=conn.create_channel
    q=@delayed_chan.queue("#{@queue_name}_deferred",
      durable: true,
      arguments: {
          'x-message-ttl' => @deferred_time,
          'x-dead-letter-exchange' => @exchange_name,
          'x-dead-letter-routing-key' => routing_key,
        }
      )
    q.publish(msg, :routing_key => routing_key)
  end

end
