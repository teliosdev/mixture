# encoding: utf-8

module Mixture
  module Types
    # A class type.  This can be subtyped, and is subtyped for
    # non-primitive classes.
    class Class < Object
      options[:primitive] = ::Class
      options[:noinfer]   = true
      options[:member]    = Object
      options[:method]    = :to_class
      options[:types]     = ThreadSafe::Cache.new
      extend Access
    end
  end
end
