#!/usr/bin/env ruby
# encoding: utf-8


GoogleDirectoryDaemon.configure do
  account_class_name=GoogleDirectoryDaemon.config["account_api"]["class"]
  account_api_clazz = account_class_name.split('::').inject(Object) {|o,c| o.const_get c}
  GoogleDirectoryDaemon.set_account_api_service account_api_clazz.new(*GoogleDirectoryDaemon.config["account_api"]["params"])

  email_class_name=GoogleDirectoryDaemon.config["email_api"]["class"]
  email_api_clazz = email_class_name.split('::').inject(Object) {|o,c| o.const_get c}
  GoogleDirectoryDaemon.set_email_api_service email_api_clazz.new(*GoogleDirectoryDaemon.config["email_api"]["params"])

  google_class_name=GoogleDirectoryDaemon.config["google_api"]["class"]
  google_api_clazz = google_class_name.split('::').inject(Object) {|o,c| o.const_get c}
  GoogleDirectoryDaemon.set_google_api_service google_api_clazz.new(*GoogleDirectoryDaemon.config["google_api"]["params"])
end
