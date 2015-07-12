# encoding: utf-8

module Mixture
  module Types
    # A string.
    class String < Object
      options[:primitive] = ::String
      options[:method] = :to_string
      as :str, :string
    end
  end
end
