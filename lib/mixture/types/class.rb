# encoding: utf-8

module Mixture
  module Types
    # A class type.  This can be subtyped, and is subtyped for
    # non-primitive classes.
    class Class < Object
      register
      options[:primitive] = ::Class
      options[:noinfer]   = true
      options[:members]   = [Object]
      options[:method]    = :to_class
      options[:types]     = ThreadSafe::Cache.new
      extend Access

      constraints.clear
      constraint do |value|
        if value.is_a?(::Class)
          options.fetch(:members).first == value
        else
          options.fetch(:members).first === value
        end
      end
    end
  end
end
