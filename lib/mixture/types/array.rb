# encoding: utf-8
# frozen_string_literal: true

module Mixture
  module Types
    # The array type.  This is a collection, and as such, can be used
    # with the `.[]` accessor.
    class Array < Collection
      register
      options[:primitive] = ::Array
      options[:method] = :to_array
      as :array
    end
  end
end
