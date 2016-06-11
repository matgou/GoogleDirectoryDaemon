#!/usr/bin/env ruby
# encoding: utf-8

class AccountsApiStub
  def initialize(firstname = "Foo", lastname = "Bared", password = "foObAr")
      @firstname = firstname
      @lastname  = lastname
      @password  = password
  end
  def getData(id)
      return {"firstname" => @firstname, "lastname" => @lastname}
  end

  def getPassword(id)
      return @password
  end
end
