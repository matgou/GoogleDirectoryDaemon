#!/usr/bin/env ruby
# encoding: utf-8

class DefaultMessageHandler

  # This handler is based on straightforward orders passed to the daemon
  #
  # Exemple message body :
  # {
  #   "action": "create",
  #   "data": {
  #     "primary_email": "john.doe@my_domain.org",
  #     "name": {
  #       "family_name": "Doe",
  #       "given_name": "John",
  #     },
  #     "password": "11b2a5d9c9bb1633fdc13ac114d7f75031aef9dc",
  #     "hash_function": "SHA-1"
  #   }
  # }
  #
  # It accepts 3 actions :
  #  - create
  #  - update
  #  - delete

  def initialize msg
    begin
      body=JSON.parse(msg)

      data= prepare_data(body["data"])

      case body['action']
      when "delete"
        delete_user data
      when "update"
        update_user data
      when "create"
        create_user data
      else
        error("Unknown action requested")
      end
    rescue JSON::ParserError => e
      error("Unable to parse JSON message body")
    end
  end

  # Expect data to contain :
  #  -primaryEmail
  def delete_user data
    if data.values_at(:primary_email).all?
      GUser.new(**data).delete
      puts " [x] User #{data[:primary_email]} deleted"
    else
      error("Invalid Data")
    end
  end

  # Expect data to contain :
  #  -primaryEmail
  def update_user data
    if data.values_at(:primary_email).all?
      GUser.new(**data).save
      puts " [x] User #{data[:primary_email]} updated"
    else
      error("Invalid Data")
    end
  end

  # Expect data to contain :
  #  -name
  #  -password
  #  -primary_email
  def create_user data
    if data.values_at(:name,:password,:primary_email).all?
      unless GUser.find(data[:primary_email])
        user=GUser.new
        user.update!(**data)
        user.save
        puts " [x] User #{data[:primary_email]} created"
      else
        error("Existing user")
      end
    else
      error("Invalid Data")
    end
  end  

  def prepare_data data
    s2s = 
    lambda do |h| 
      Hash === h ? 
        Hash[
          h.map do |k, v| 
            [k.respond_to?(:to_sym) ? k.to_sym : k, s2s[v]] 
          end 
        ] : h 
    end
    s2s[data]
  end


  def error(msg)
    puts " [*] ERROR : #{msg}"
  end

end
