#!/usr/bin/env ruby
# encoding: utf-8

class GoogleApiStub
  def data
      return @data
  end

  def createAccount(data)
      puts data.inspect
      @data = data
  end
end
