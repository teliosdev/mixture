# encoding: utf-8

module Mixture
  module Types
    # An integer.  Not much to say here.
    class Integer < Numeric
      register
      options[:primitive] = ::Integer
      options[:method] = :to_integer
      as :int, :integer
    end
  end
end
