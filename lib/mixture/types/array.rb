# encoding: utf-8

module Mixture
  module Types
    # The array type.  This is a collection, and as such, can be used
    # with the `.[]` accessor.
    class Array < Collection
      options[:primitive] = ::Array
      options[:method] = :to_array
      as :array
    end
  end
end
