# encoding: utf-8

module Mixture
  module Types
    # A collection.  This is recognized as an actual set of values,
    # rather than just being enumerable.  The set of values have a
    # defined type.
    class Collection < Enumerable
      options[:members] = [Object]
      options[:types]   = ThreadSafe::Cache.new
      extend Access
    end
  end
end
