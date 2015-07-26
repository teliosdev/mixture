# encoding: utf-8

module Mixture
  module Types
    # A date type.  I don't know why ruby has Date, DateTime, and
    # Time, but someone thinks we need it.
    class Date < Object
      register
      options[:primitive] = ::Date
      options[:method] = :to_date
      as :date
    end
  end
end
