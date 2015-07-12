# encoding: utf-8

module Mixture
  module Types
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
