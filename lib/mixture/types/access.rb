# encoding: utf-8

module Mixture
  module Types
    # Used by certain types to create subtypes of those types.  This
    # is useful in collections and hashes, wherein the collection
    # members and hash keys/values all have types as well (and need
    # to be coerced to them).
    module Access
      # Creates a subtype with the given member types.  Any number of
      # subtypes may be used.  If a class hasn't been created with the
      # subtypes, it creates a new one.
      #
      # @see #create
      # @param subs [Object] The subtypes to use.
      # @return [Class] The new subtype.
      def [](*subs)
        options[:types].fetch([self, subs]) do
          create(subs)
        end
      end

      private

      # Actually creates the subtype.  This should never be called
      # outside of {.[]}.  If `:noinfer` is set in the supertype's
      # options, it doesn't infer the type of each subtype; otherwise,
      # it does.
      #
      # @param subs [Array<Object>] The subtypes.
      # @return [Class] The new subtype.
      def create(subs)
        subtype = ::Class.new(self)
        members = if options[:noinfer]
                    subs
                  else
                    subs.map { |sub| Types.infer(sub) }
                  end
        name    = "#{inspect}[#{members.join(', ')}]"
        subtype.options.merge!(members: members, name: name)
        options[:types][[self, subs]] = subtype
      end
    end
  end
end
