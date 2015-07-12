# encoding: utf-8

module Mixture
  module Types
    class DateTime < Object
      options[:primitive] = ::DateTime
      options[:method] = :to_datetime
      as :datetime
    end
  end
end
