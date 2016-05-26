#!/usr/bin/env ruby
# encoding: utf-8

require 'google/apis/admin_directory_v1'

class DirectoryService < Google::Apis::AdminDirectoryV1::DirectoryService

  def initialize
    super
    self.client_options.application_name = AppConfig.value_at('application_name')
    authorizer = Object.const_get(AppConfig.value_at('authorizer'))
    self.authorization = authorizer.authorize

    self
  end
end