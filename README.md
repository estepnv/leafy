# Leafy [![Build Status](https://travis-ci.org/estepnv/leafy.svg?branch=master)](https://travis-ci.org/estepnv/leafy) [![Maintainability](https://api.codeclimate.com/v1/badges/5108d8a1ac5e2915f30f/maintainability)](https://codeclimate.com/github/estepnv/leafy/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/5108d8a1ac5e2915f30f/test_coverage)](https://codeclimate.com/github/estepnv/leafy/test_coverage)

A toolkit for dynamic custom attributes for Ruby applications.

* Simple modular design - load only things you need
* Stored as JSON with your models - allows you to avoid expensive JOIN queries (supports postgresql json/jsonb data types)
* Type inference - Infers type from custom field data
* Add your own custom field types

Supported data types:
- `string` - strings
- `integer` - integer numbers
- `double` - floating point numbers
- `datetime` - `Time` instances
- `date` - `Date` instances
- `bool` - `TrueClass` and `FalseClass` instances

## Quick start

Add Leafy to Gemfile

```ruby
gem 'leafy-ruby'
```

**Plain Ruby app**

Include "Plain old ruby object" mixin into your class definition to start using leafy

```ruby
class SchemaHost < ActiveRecord::Base
  include Leafy::Mixin::Schema[:poro]

  attr_accessor :leafy_data
end

class FieldsHost < ActiveRecord::Base
  include Leafy::Mixin::Fields[:poro]

  attr_accessor :leafy_data
  attr_accessor :leafy_fields
end
```

Schema mixin introduces next methods:

- `#leafy_fields (Schema)` returns Schema instance allowing you to iterate through custom attribute definitions.
- `#leafy_fields=` schema setter method
- `#leafy_fields_attributes=` nested attributes setter method

Fields mixin:

- `#leafy_values (Hash)` returns a hash representation of your fields data
- `#leafy_values=` allows you to assign custom attributes data
- `#leafy_fields_values (Leafy::FieldValueCollection)`  returns a collection of `Field::Value` instances which provide more control over values data

**Please note**:
Leafy is stateless and changing Schema instance won't reflect on your active record model instance.
For changes to take place you have to explicitly assign schema or attributes data to the model.



```ruby
host = SchemaHost.new
host.leafy_fields_attributes = [
  { name: "Field 1", type: :integer, id: "id_1", metadata: { default: 1, placeholder: "enter an integer", required: true } },
  { name: "Field 2", type: :string, id: "id_2", metadata: { default: "", placeholder: "enter value" } },
  { name: "Field 3", type: :datetime, id: "id_3", metadata: { order: 10000 } }
]

# or build schema yourself

field_1 = Leafy::Field.new(name: "Field 1", type: :integer, id: "id_1", metadata: { default: 1, placeholder: "enter an integer", required: true })
field_2 = Leafy::Field.new(name: "Field 2", type: :string, id: "id_2", metadata: { default: "", placeholder: "enter value" })
field_3 = Leafy::Field.new(name: "Field 3", type: :datetime, id: "id_3", metadata: { order: 10000 })

schema = Leafy::Schema.new
schema << field_1
schema << field_2
schema << field_3

host.leafy_fields = schema

# after that reference schema for fields target instance

target = FieldsHost.new
target.leafy_fields = host.leafy_fields
target.leafy_values

# => { "id_1" => nil, "id_2" => nil, "id_3" => nil }

target.leafy_values = { "id_1": 123, "id_2": "test", "id_3": Time.new(2018,10,10, 10,10,10, "+03:00"), "junk": "some junk data" }
target.leafy_values

# => { "id_1": 123, "id_2": "test", "id_3": Time.new(2018,10,10, 10,10,10, "+03:00") }
```

**ActiveRecord**

Add migration
```ruby
add_column :schema_hosts, :leafy_data, :text, null: false, default: "{}"
add_column :fields_hosts, :leafy_data, :text, null: false, default: "{}"
# for postgresql
# add_column :leafy_data, :jsonb, null: false, default: {}
```

Update your models

```ruby
class SchemaHost < ActiveRecord::Base
  include Leafy::Mixin::Schema[:active_record]
end

class FieldsHost < ActiveRecord::Base
  include Leafy::Mixin::Fields[:active_record]

  belongs_to :schema_host, required: true
  delegate :leafy_fields, to: :schema_host
end
```

```ruby
host = SchemaHost.create(
  leafy_fields_attributes: [
    { name: "Field 1", type: :integer, id: "id_1", metadata: { default: 1, placeholder: "enter an integer", required: true } },
    { name: "Field 2", type: :string, id: "id_2", metadata: { default: "", placeholder: "enter value" } },
    { name: "Field 3", type: :datetime, id: "id_3", metadata: { order: 10000 } }
  ]
)

target = FieldsHost.create(schema_host: host)
target.leafy_values

# => { "id_1" => nil, "id_2" => nil, "id_3" => nil }

target.leafy_values = { "id_1": 123, "id_2": "test", "id_3": Time.new(2018,10,10, 10,10,10, "+03:00"), "junk": "some junk data" }
target.save!
target.reload

target.leafy_values

# => { "id_1": 123, "id_2": "test", "id_3": Time.new(2018,10,10, 10,10,10, "+03:00") }
```

## Configuration

In you initialization code

If you get a `NameError: uninitialized constant` in Rails, please ensure you have required leafy in an initializer.

in `app/config/initializers/leafy.rb` simply add `require 'leafy'`

```ruby
class MyLovelyCoder
  def dump(data)
    "lovely_#{data}"
  end

  def load(data)
    data.split("_")[1]
  end
end

Leafy.configure do |config|
  # you may wonna use oj instead
  config.coder = MyLovelyCoder.new
end
```

## Adding your own types

Leafy allows adding your own data types
To allow leafy process your own data type you need to describe how to store it. For that purpose leafy utilizes converter classes associated for each type.

Converter instance has to implement `#dump` and `#load` methods

```ruby
class MyComplexTypeConverter
  def self.load(json_string)
    #  parsing logic
    return MyComplexType.new(parsed_data)
  end

  def self.dump(my_complex_type_instance)
    # serializing logic
    return json
  end
end

Leafy.register_converter(:complex_type, MyComplexTypeConverter)
```



## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/estepnv/leafy.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
