# encoding: utf-8
# frozen_string_literal: true

module Mixture
  module Types
    # A datetime type.  I don't know why Ruby has a Date, DateTime, and
    # Time type, but someone thinks we needs it.
    class DateTime < Object
      register
      options[:primitive] = ::DateTime
      options[:method] = :to_datetime
      as :datetime
    end
  end
end
