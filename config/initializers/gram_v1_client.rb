#!/usr/bin/env ruby
# encoding: utf-8

require 'gram_v1_client'

GramV1Client.configure do |c|
   # Base URI used to access GrAM API
   c.site=GoogleDirectoryDaemon.config["gram_api_host"]
   # Username provided by Gadz.org
   c.user=GoogleDirectoryDaemon.config["gram_api_user"]
   # Password provided by Gadz.org
   c.password=GoogleDirectoryDaemon.config["gram_api_password"]
   # If your app use a proxy to access net, put it here
   #c.proxy="my_proxy"
 end