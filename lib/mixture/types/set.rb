# encoding: utf-8

module Mixture
  module Types
    class Set < Collection
      options[:primitive] = ::Set
      options[:method] = :to_set
      as :set
    end
  end
end
