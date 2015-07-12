# encoding: utf-8

module Mixture
  module Types
    class Array < Collection
      options[:primitive] = ::Array
      options[:method] = :to_array
      as :array
    end
  end
end
