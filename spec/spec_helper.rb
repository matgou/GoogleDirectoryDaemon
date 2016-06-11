require "codeclimate-test-reporter"

BIN_BASE_PATH=File.expand_path('..',File.dirname(__FILE__))
require File.join(BIN_BASE_PATH,"google_directory_daemon.rb")


CodeClimate::TestReporter.start

