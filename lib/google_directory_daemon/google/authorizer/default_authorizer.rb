#!/usr/bin/env ruby
# encoding: utf-8

require 'googleauth'
require 'googleauth/stores/file_token_store'

class DefaultAuthorizer

  OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'

  def self.authorize
    user_id=AppConfig.value_at('admin_user_id')
    scope = 'https://www.googleapis.com/auth/admin.directory.user'
    client_id = Google::Auth::ClientId.from_file(File.join(BASE_PATH,'secrets/client_secret.json'))
    token_store = Google::Auth::Stores::FileTokenStore.new(
      :file => File.join(BASE_PATH,'secrets/tokens.yaml'))
    authorizer = Google::Auth::UserAuthorizer.new(client_id, scope, token_store)

    credentials = authorizer.get_credentials(user_id)
    if credentials.nil?
      url = authorizer.get_authorization_url(base_url: OOB_URI )
      puts "Open #{url} in your browser and enter the resulting code:"
      code = gets
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: OOB_URI)
    end

    credentials
  end

end