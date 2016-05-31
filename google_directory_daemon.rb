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
  c.application_name="GoogleDirectoryDaemon-test-kapable"
  c.application_id="gapps_kapable"
  c.rabbitmq_host=AppConfig.value_at('rabbitmq_host')
  c.rabbitmq_port=AppConfig.value_at('rabbitmq_port')
  c.rabbitmq_user=AppConfig.value_at('rabbitmq_user')
  c.rabbitmq_password=AppConfig.value_at('rabbitmq_password')
  c.rabbitmq_queue_name=AppConfig.value_at('rabbitmq_queue_name')
  c.rabbitmq_exchange_name=AppConfig.value_at('rabbitmq_exchange_name')
  c.rabbitmq_vhost=AppConfig.value_at('rabbitmq_vhost')
  c.rabbitmq_deferred_time=1000
  c.message_handler_map=AppConfig.value_at('message_handler_map').inject({}){|o,(k,v)| o[k]=Object.const_get(v); o}
end

class GoogleDirectoryDaemon

  def initialize
    GorgService.new.run
  end
  
end
