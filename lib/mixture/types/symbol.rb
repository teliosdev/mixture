# encoding: utf-8

module Mixture
  module Types
    class Symbol < Object
      options[:primitive] = ::Symbol
      options[:method] = :to_symbol
      as :symbol
    end
  end
end
