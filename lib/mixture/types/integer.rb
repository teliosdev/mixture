# encoding: utf-8
# frozen_string_literal: true

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
