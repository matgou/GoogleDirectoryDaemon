#!/usr/bin/env ruby
# encoding: utf-8

class CreateUserMessageHandler < GorgService::MessageHandler

  def initialize msg
    # Get Id from message
    id=msg.data[:id_soce]

    # Register services
    account_api = register_account_api_service
    email_api   = register_email_api_service
    google_api  = register_google_api_service

    # get Hash for account
    account = account_api.getData(id)
    if account
      puts " [x] Account n°#{id} exists"

      # Maps Gram attributes
      firstname = account['firstname']
      lastname  = account['lastname']

      # Get password from gram_Api
      password = account_api.getPassword(id)

      # Get email from gorg_mail
      email = email_api.getMainEmail(id)

      data = {
          'password' => password,
          'primaryEmail' => email,
          'name' => {
              'familyName' => lastname,
              'givenName' => firstname
          }
      }
      google_api.createAccount(data)

    else
      puts " [x] Account n°#{id} doesn't exist in GRAM"
    end
  end

  def register_google_api_service
      return GoogleDirectoryDaemon.google_api_service
  end

  def register_email_api_service
      return GoogleDirectoryDaemon.email_api_service
  end

  def register_account_api_service
      return GoogleDirectoryDaemon.account_api_service
  end
end
