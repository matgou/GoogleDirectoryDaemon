#!/usr/bin/env ruby
# encoding: utf-8

class EmailApiStub

  def initialize(mainEmail = "foo.bar@poubs.org")
      @mainEmail = mainEmail
  end

  def getMainEmail(id)
      return @mainEmail
  end
end
