# encoding: utf-8

module Mixture
  module Types
    # A symbol.  Don't really use this for coercion; in Ruby 2.2.2,
    # they added garbage collection for symbols; however, it is still
    # not a brilliant idea to turn user input into symbols.
    class Symbol < Object
      register
      options[:primitive] = ::Symbol
      options[:method] = :to_symbol
      as :symbol
    end
  end
end
