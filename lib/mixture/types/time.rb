# encoding: utf-8

module Mixture
  module Types
    class Time < Object
      options[:primitive] = ::Time
      options[:method] = :to_time
      as :time
    end
  end
end
