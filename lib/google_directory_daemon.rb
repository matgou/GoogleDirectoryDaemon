#!/usr/bin/env ruby
# encoding: utf-8

BASE_PATH=File.expand_path('..',File.dirname(__FILE__))

Dir[File.join(BASE_PATH,"lib/google_directory_daemon/authorizer/*.rb")].each {|file| require file }
Dir[File.join(BASE_PATH,"lib/google_directory_daemon/message_handler/*.rb")].each {|file| require file }
require File.join(BASE_PATH,'lib/google_directory_daemon/listener.rb')
require File.join(BASE_PATH,'lib/google_directory_daemon/directory_service.rb')
require File.join(BASE_PATH,'lib/google_directory_daemon/user.rb')

require 'yaml'


class Config
  def self.value_at key
    @conf||=YAML::load(File.open(File.join(BASE_PATH,'config/conf.yml')))
    @conf[key]
  end
end


class GoogleDirectoryDaemon

  def initialize()
    listnr=Listener.new(
      message_handler:Object.const_get(Config.value_at('message_handler')),
      host: Config.value_at('rabbitmq_host'),
      port: Config.value_at('rabbitmq_port'),
      queue_name: Config.value_at('rabbitmq_queue_name'),
      exchange_name: Config.value_at('rabbitmq_exchange_name'),
      rabbitmq_user: Config.value_at('rabbitmq_user'),
      rabbitmq_password: Config.value_at('rabbitmq_password')
      )
    listnr.listen
  end
end

GoogleDirectoryDaemon.new()
