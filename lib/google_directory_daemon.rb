#!/usr/bin/env ruby
# encoding: utf-8

BASE_PATH=File.expand_path('..',File.dirname(__FILE__))
class AppConfig
  def self.value_at key
    @conf||=YAML::load(File.open(File.join(BASE_PATH,'config/conf.yml')))
    @conf[key]
  end
end

Dir[File.join(BASE_PATH,"lib/google_directory_daemon/google/authorizer/*.rb")].each {|file| require file }
Dir[File.join(BASE_PATH,"lib/google_directory_daemon/message_handler/*.rb")].each {|file| require file }
require File.join(BASE_PATH,'lib/google_directory_daemon/errors.rb')
require File.join(BASE_PATH,'lib/google_directory_daemon/message.rb')
require File.join(BASE_PATH,'lib/google_directory_daemon/listener.rb')
require File.join(BASE_PATH,'lib/google_directory_daemon/google/directory_service.rb')
require File.join(BASE_PATH,'lib/google_directory_daemon/google/g_user.rb')
require File.join(BASE_PATH,'lib/google_directory_daemon/gram/json_formater.rb')
require File.join(BASE_PATH,'lib/google_directory_daemon/gram/gram_account.rb')
require File.join(BASE_PATH,'lib/google_directory_daemon/gram/gram_email.rb')
require File.join(BASE_PATH,'lib/google_directory_daemon/gram/gram_search.rb')


require 'yaml'




class GoogleDirectoryDaemon

  def initialize()
    message_handler_map=AppConfig.value_at('message_handler_map').inject({}){|o,(k,v)| o[k]=Object.const_get(v); o}

    listnr=Listener.new(
      message_handler_map:message_handler_map,
      host: AppConfig.value_at('rabbitmq_host'),
      port: AppConfig.value_at('rabbitmq_port'),
      queue_name: AppConfig.value_at('rabbitmq_queue_name'),
      exchange_name: AppConfig.value_at('rabbitmq_exchange_name'),
      rabbitmq_user: AppConfig.value_at('rabbitmq_user'),
      rabbitmq_password: AppConfig.value_at('rabbitmq_password'),
      deferred_time: AppConfig.value_at('rabbitmq_deferred_time'),
      )
    listnr.listen
  end
end

GoogleDirectoryDaemon.new()
