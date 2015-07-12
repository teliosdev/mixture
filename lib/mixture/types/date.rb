# encoding: utf-8

module Mixture
  module Types
    class Date < Object
      options[:primitive] = ::Date
      options[:method] = :to_date
      as :date
    end
  end
end
