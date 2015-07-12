# encoding: utf-8

module Mixture
  module Types
    module Access
      def [](*subs)
        key = [self].concat(subs)

        options[:types].fetch(key) do
          subtype = ::Class.new(self)
          members = if options[:noinfer]
                      subs
                    else
                      subs.map { |sub| Types.infer(sub) }
                    end
          name    = "#{inspect}[#{members.join(', ')}]"
          subtype.options.merge!(members: members, name: name)
          options[:types][key] = subtype
        end
      end
    end
  end
end
