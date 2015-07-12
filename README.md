# Mixture

[![Build Status](https://travis-ci.org/medcat/mixture.svg?branch=master)](https://travis-ci.org/medcat/mixture) [![Coverage Status](https://coveralls.io/repos/medcat/mixture/badge.svg?branch=master&service=github)](https://coveralls.io/github/medcat/mixture?branch=master) [![Gem Version](https://badge.fury.io/rb/mixture.svg)](http://badge.fury.io/rb/mixture)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mixture'
```

And then execute:

    $ bundle

## Usage

It's simple, really.

```ruby
module MyLibrary
  class MyClass
    include Mixture::Model
  end
end
```

This provides a few simple things.  First off, it provides the
`.attribute` class method.  The attribute class method allows you to
define an attribute on your class.  Attributes use the instance
variables just like `attr_reader`/`attr_writer` do - but it also
allows coercion on assignment, as well.  Defining an attribute is as
simple as `attribute :name`.  This provides the `:name` and `:name=`
methods on the instance.

You also get access to the `#attributes=`, `#attributes`, and
`#attribute` instance methods.  The first group assigns attributes,
running it through any update callbacks defined.  The second retrieves
the attributes on the instance, even if they weren't assigned.  The
last provides easy get/set functionality.

If you want to take advantage of the coercion abilities, just add a
`:type` key to the options for the attribute:

```ruby
module MyLibrary
  class MyClass
    include Mixture::Model

    attribute :name, type: String
  end
end
```

This will automagically cause `name` to be coerced to a string on
assignment.

For validation, use the `.validate` class method:

```ruby
module MyLibrary
  class MyClass
    include Mixture::Model
    attribute :name, type: String
    validate :name, format: /^.{3,20}$/
  end
end
```

Some validators are available by default:

- `:exclusion` - Validates that the value for the attribute is not
  within a given set of values.
- `:inclusion` - Validates that the value for the attribute _is_
  within a given set of values.
- `:length` - Validates that the value for the attribute is within a
  certain length.
- `:match` - Validates that the value for the attribute matches a
  regular expression.  This is also known as `:format`.
- `:presence` - Validates that the value is not nil and isn't empty
  (by checking for `#empty?`).

Adding a validator is simple:

```ruby
module MyLibrary
  class MyValidator < Mixture::Validate::Base
    # This registers it with Mixture, so it can be used within a
    # `validate` call.
    register_as :my_validator

    def validate(record, attribute, value)
      # this sets instance variables mapping the above arguments.
      super
      my_super_awesome_validation
    end
  end
end
```

Adding a coercer is also simple:

```ruby
module MyLibrary
  module Types
    class MyObject < Mixture::Types::Object
      options[:primitive] = nil
      constraint { |value| ... }
    end
  end
  module Coerce
    class MyObject < Mixture::Coerce::Base
      type MyLibrary::Types::MyObject

      coerce_to(Mixture::Types::Array) do |value|
        value.to_a
      end
    end
  end
end
```

Although the builtin coercers should do well.

A more complex example:

```ruby
module MyLibrary
  class Something
    include Mixture::Model

    attribute :name, type: String
    attribute :files, type: Array[String]
    attribute :authors, type: Set[Author]
    attribute :dependencies, type: Set[Dependency]
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/medcat/mixture.  This project is intended to be a
safe, welcoming space for collaboration, and contributors are expected
to adhere to the [Contributor Covenant](contributor-covenant.org) code
of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
