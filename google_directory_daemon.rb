#!/usr/bin/env ruby
# encoding: utf-8

require 'yaml'
require 'gorg_service'


BASE_PATH=File.dirname(__FILE__)
Dir[File.join(BASE_PATH,"app","**","*.rb")].each {|file| require file }

class AppConfig
  def self.value_at key
    @conf||=YAML::load(File.open(File.join(BASE_PATH,'config','conf.yml')))
    @conf[key]
  end
end


GorgService.configure do |c|
  c.application_name="GoogleDirectoryDaemon-test"
  c.application_id="gdd-t"
  c.rabbitmq_host="localhost"
  c.rabbitmq_port=5672
  c.rabbitmq_queue_name="gapps4"
  c.rabbitmq_exchange_name="agoram_event_exchange"
  c.rabbitmq_deferred_time=1000
  c.message_handler_map={"request.gapps.create" => DefaultMessageHandler}
end

class GoogleDirectoryDaemon

  def initialize
    GorgService.new.run
  end
  
end