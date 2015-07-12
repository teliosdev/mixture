# encoding: utf-8

module Mixture
  module Types
    class Collection < Enumerable
      options[:members] = [Object]
      options[:types]   = ThreadSafe::Cache.new
      extend Access
    end
  end
end
