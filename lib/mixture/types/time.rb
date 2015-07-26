# encoding: utf-8

module Mixture
  module Types
    # A time type.  I'm not sure why Ruby has a Date, DateTime, and
    # Time object, but someone thinks we need it.
    class Time < Object
      register
      options[:primitive] = ::Time
      options[:method] = :to_time
      as :time
    end
  end
end
