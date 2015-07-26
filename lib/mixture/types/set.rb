# encoding: utf-8

module Mixture
  module Types
    # A set.  This is similar to array, but with brilliant iteration
    # and indexing(?) times.
    #
    # @see Array
    # @see http://ruby-doc.org/stdlib/libdoc/set/rdoc/Set.html
    class Set < Collection
      register
      options[:primitive] = ::Set
      options[:method] = :to_set
      as :set
    end
  end
end
