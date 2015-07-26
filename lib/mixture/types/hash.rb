# encoding: utf-8

module Mixture
  module Types
    # A hash.  This is also accessable, and expects two member types;
    # one for the keys, and one for the values.
    class Hash < Object
      register
      options[:primitive] = ::Hash
      options[:members]   = [Object, Object]
      options[:method]    = :to_hash
      options[:types]     = ThreadSafe::Cache.new
      extend Access
    end
  end
end
