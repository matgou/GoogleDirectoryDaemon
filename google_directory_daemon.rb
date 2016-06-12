#!/usr/bin/env ruby
# encoding: utf-8

require 'yaml'
require 'gorg_service'

$LOAD_PATH << File.join(Dir.pwd,'app')


class GoogleDirectoryDaemon
  @@account_api_service = nil
  @@email_api_service = nil
  @@google_api_service = nil

  RAW_CONFIG ||= YAML::load(File.open(File.expand_path("config/config.yml")))
  ENV['GOOGLE_DIRECTORY_DAEMON_ENV']||="development"

  def initialize
    @gorg_service=GorgService.new
  end

  def self.configure
     yield
  end

  # getter
  def self.account_api_service
      return @@account_api_service
  end
  def self.email_api_service
      return @@email_api_service
  end
  def self.google_api_service
      return @@google_api_service
  end

  # setter
  def self.set_account_api_service service
      @@account_api_service = service
  end
  def self.set_email_api_service service
      @@email_api_service = service
  end
  def self.set_google_api_service service
      @@google_api_service = service
  end
  

 def run
    begin
      self.start
      puts " [*] Waiting for messages. To exit press CTRL+C"
      loop do
        sleep(1)
      end
    rescue SystemExit, Interrupt => _
      self.stop
    end
  end

  def start
    @gorg_service.start
  end

  def stop
    @gorg_service.stop
  end

  def self.config
    RAW_CONFIG[ENV['GOOGLE_DIRECTORY_DAEMON_ENV']]
  end

  def self.root
    File.dirname(__FILE__)
  end
end

Dir[File.expand_path("../app/**/*.rb",__FILE__)].each {|file| require file }
Dir[File.expand_path("../lib/**/*.rb",__FILE__)].each {|file| require file }
Dir[File.expand_path("../config/initializers/*.rb",__FILE__)].each {|file|require file }
