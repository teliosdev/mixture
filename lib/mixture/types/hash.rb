# encoding: utf-8

module Mixture
  module Types
    class Hash < Object
      options[:primitive] = ::Hash
      options[:members]   = [Object, Object]
      options[:method]    = :to_hash
      options[:types]     = ThreadSafe::Cache.new
      extend Access
    end
  end
end
