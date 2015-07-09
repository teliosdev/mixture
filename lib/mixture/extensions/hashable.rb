# encoding: utf-8

require "forwardable"

module Mixture
  module Extensions
    # Has the mixture respond to `#[]` and `#[]=`.
    module Hashable
      extend Forwardable
      include Enumerable
      include Comparable

      delegate [:each, :<=>] => :attributes

      def [](key)
        attribute(key.to_s.intern)
      end

      def []=(key, value)
        attribute(key.to_s.intern, value)
      end

      def key?(key)
        self.class.attributes.key?(key.to_s.intern)
      end

      def fetch(key, default = Unknown)
        case
        when key?(key.to_s.intern) then attribute(key.to_s.intern)
        when block_given?          then yield(key.to_s.intern)
        when default != Unknown    then default
        else fail KeyError, "Undefined attribute #{key.to_s.intern}"
        end
      end
    end
  end
end
