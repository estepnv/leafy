# Leafy [![CI](https://github.com/estepnv/leafy/actions/workflows/ci.yml/badge.svg)](https://github.com/estepnv/leafy/actions/workflows/ci.yml) [![codecov](https://codecov.io/gh/estepnv/leafy/branch/master/graph/badge.svg)](https://codecov.io/gh/estepnv/leafy) [![Maintainability](https://api.codeclimate.com/v1/badges/5108d8a1ac5e2915f30f/maintainability)](https://codeclimate.com/github/estepnv/leafy/maintainability)

A toolkit for dynamic custom attributes for Ruby applications.

## Table of Contents

- [Features](#features)
- [Supported Data Types](#supported-data-types)
- [Installation](#installation)
- [Requirements](#requirements)
- [Quick Start](#quick-start)
  - [Plain Ruby Objects (PORO)](#plain-ruby-objects-poro)
  - [ActiveRecord Integration](#activerecord-integration)
- [Configuration](#configuration)
- [Custom Field Types](#custom-field-types)
- [Best Practices](#best-practices)
- [API Reference](#api-reference)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Features

* **Simple modular design** - Load only what you need
* **JSON-backed storage** - Store custom fields as JSON with your models, avoiding expensive JOIN queries
* **PostgreSQL support** - Native support for `json` and `jsonb` column types
* **Type safety** - Automatic type inference and validation for custom field data
* **Extensible** - Add your own custom field types with converters
* **Thread-safe** - Safe for concurrent access

## Supported Data Types

- `string` - String values
- `integer` - Integer numbers
- `double` - Floating point numbers
- `datetime` - `Time` instances (stored as ISO8601)
- `date` - `Date` instances (stored as ISO8601)
- `bool` - Boolean values (`true`/`false`)
- `dummy` - Pass-through type (no conversion)

## Installation

Add Leafy to your Gemfile:

```ruby
gem 'leafy-ruby'
```

Then run:

```bash
bundle install
```

## Requirements

- Ruby 2.7 or higher
- ActiveRecord 6.0+ (optional, only if using ActiveRecord integration)

## Quick Start

## Quick Start

### Plain Ruby Objects (PORO)

For plain Ruby objects, include the `:poro` mixin and provide a `leafy_data` accessor:

```ruby
class SchemaHost
  include Leafy::Mixin::Schema[:poro]

  attr_accessor :leafy_data
end

class FieldsHost
  include Leafy::Mixin::Fields[:poro]

  attr_accessor :leafy_data
  attr_accessor :leafy_fields
end
```

**Schema mixin provides:**

- `#leafy_fields` - Returns a `Leafy::Schema` instance for iterating through custom field definitions
- `#leafy_fields=` - Schema setter method
- `#leafy_fields_attributes=` - Nested attributes setter method

**Fields mixin provides:**

- `#leafy_values` - Returns a hash of field values
- `#leafy_values=` - Assigns custom field values
- `#leafy_field_values` - Returns a `Leafy::FieldValueCollection` for fine-grained control

**Important:** Leafy is stateless. Changing a Schema instance won't automatically update your model. You must explicitly assign the schema or attributes to persist changes.

#### Example Usage

```ruby
# Create a schema host
host = SchemaHost.new

# Define custom fields using attributes
host.leafy_fields_attributes = [
  { 
    name: "Field 1", 
    type: :integer, 
    id: "id_1", 
    metadata: { default: 1, placeholder: "Enter an integer", required: true } 
  },
  { 
    name: "Field 2", 
    type: :string, 
    id: "id_2", 
    metadata: { default: "", placeholder: "Enter value" } 
  },
  { 
    name: "Field 3", 
    type: :datetime, 
    id: "id_3", 
    metadata: { order: 10000 } 
  }
]

# Or build the schema manually
field_1 = Leafy::Field.new(
  name: "Field 1", 
  type: :integer, 
  id: "id_1", 
  metadata: { default: 1, placeholder: "Enter an integer", required: true }
)
field_2 = Leafy::Field.new(
  name: "Field 2", 
  type: :string, 
  id: "id_2", 
  metadata: { default: "", placeholder: "Enter value" }
)
field_3 = Leafy::Field.new(
  name: "Field 3", 
  type: :datetime, 
  id: "id_3", 
  metadata: { order: 10000 }
)

schema = Leafy::Schema.new
schema << field_1
schema << field_2
schema << field_3

host.leafy_fields = schema

# Use the schema with a fields host
target = FieldsHost.new
target.leafy_fields = host.leafy_fields

# Initial values are nil
target.leafy_values
# => { "id_1" => nil, "id_2" => nil, "id_3" => nil }

# Set values (unknown fields are ignored)
target.leafy_values = { 
  "id_1" => 123, 
  "id_2" => "test", 
  "id_3" => Time.new(2018, 10, 10, 10, 10, 10, "+03:00"), 
  "junk" => "ignored"
}

target.leafy_values
# => { "id_1" => 123, "id_2" => "test", "id_3" => 2018-10-10 07:10:10 UTC }
```

### ActiveRecord Integration

#### 1. Create a migration

```ruby
class AddLeafyData < ActiveRecord::Migration[6.1]
  def change
    # For text/string storage (all databases)
    add_column :schema_hosts, :leafy_data, :text, null: false, default: "{}"
    add_column :fields_hosts, :leafy_data, :text, null: false, default: "{}"
    
    # For PostgreSQL with native JSON support (recommended)
    # add_column :schema_hosts, :leafy_data, :jsonb, null: false, default: {}
    # add_column :fields_hosts, :leafy_data, :jsonb, null: false, default: {}
    # add_index :schema_hosts, :leafy_data, using: :gin
    # add_index :fields_hosts, :leafy_data, using: :gin
  end
end
```

#### 2. Update your models

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

#### 3. Usage

```ruby
# Create a schema host with custom fields
host = SchemaHost.create(
  leafy_fields_attributes: [
    { 
      name: "Field 1", 
      type: :integer, 
      id: "id_1", 
      metadata: { default: 1, placeholder: "Enter an integer", required: true } 
    },
    { 
      name: "Field 2", 
      type: :string, 
      id: "id_2", 
      metadata: { default: "", placeholder: "Enter value" } 
    },
    { 
      name: "Field 3", 
      type: :datetime, 
      id: "id_3", 
      metadata: { order: 10000 } 
    }
  ]
)

# Create a fields host and set values
target = FieldsHost.create(schema_host: host)

target.leafy_values
# => { "id_1" => nil, "id_2" => nil, "id_3" => nil }

target.leafy_values = { 
  "id_1" => 123, 
  "id_2" => "test", 
  "id_3" => Time.new(2018, 10, 10, 10, 10, 10, "+03:00"), 
  "junk" => "ignored" 
}
target.save!
target.reload

target.leafy_values
# => { "id_1" => 123, "id_2" => "test", "id_3" => 2018-10-10 07:10:10 UTC }
```

## Configuration

### Rails Setup

If you get a `NameError: uninitialized constant` error in Rails, create an initializer:

```ruby
# config/initializers/leafy.rb
require 'leafy'
```

### Custom Coder

By default, Leafy uses the JSON module for serialization. You can configure a custom coder (e.g., Oj for better performance):

```ruby
# config/initializers/leafy.rb
require 'leafy'
require 'oj'

class OjCoder
  def dump(data)
    Oj.dump(data)
  end

  def load(data)
    Oj.load(data)
  end
end

Leafy.configure do |config|
  config.coder = OjCoder.new
end
```

**Note:** Your coder must implement both `#dump` and `#load` instance methods.

## Custom Field Types

Leafy allows you to add your own custom data types by registering converters.

### Creating a Converter

A converter is responsible for serializing (dump) and deserializing (load) your custom type. It must implement both `#dump` and `#load` instance methods:

```ruby
class MoneyConverter
  def dump(value)
    return nil if value.nil?
    # Convert Money object to cents for storage
    value.cents.to_s
  end

  def load(value)
    return nil if value.nil?
    # Convert cents back to Money object
    Money.new(value.to_i)
  end
end

# Register the converter
Leafy.register_converter(:money, MoneyConverter.new)
```

### Using Custom Types

```ruby
schema = Leafy::Schema.new
schema << Leafy::Field.new(
  name: "Price",
  type: :money,  # Your custom type
  id: "price_field"
)

host.leafy_fields = schema
target.leafy_fields = schema

target.leafy_values = { "price_field" => Money.new(1999) }
target.leafy_values["price_field"]
# => #<Money cents=1999>
```

## Best Practices

### Field IDs

- Use stable, unique IDs for fields (UUIDs are generated automatically if not provided)
- Don't change field IDs after data has been stored
- Field IDs are the key for storing values - changing them will lose existing data

### Metadata

The `metadata` hash is completely flexible - store any additional information you need:

```ruby
metadata: {
  default: "some default",
  placeholder: "Help text",
  required: true,
  order: 100,
  validation_rules: { min: 0, max: 100 },
  custom_property: "anything you want"
}
```

### Performance Tips

- Use PostgreSQL `jsonb` columns for better query performance and indexing
- Keep the number of custom fields reasonable (< 100 per model)
- Use GIN indexes on jsonb columns for field queries
- Consider using Oj or other fast JSON libraries as your coder

### Thread Safety

Leafy's class-level configuration and converter registry are thread-safe. You can safely register converters and configure Leafy from multiple threads or in multi-threaded web servers (Puma, Sidekiq, etc.).

## API Reference

### Schema Methods

- `Leafy::Schema.new(fields_array)` - Create a new schema
- `#push(field)` / `#<<(field)` - Add a field to the schema
- `#[](identifier)` - Find a field by ID
- `#ids` - Get array of all field IDs
- `#each` - Iterate through fields (Enumerable)
- `#serializable_hash` - Convert to hash representation
- `Leafy::Schema.dump(schema)` - Serialize to JSON string
- `Leafy::Schema.load(json_string)` - Deserialize from JSON string

### Field Methods

- `Leafy::Field.new(name:, type:, id:, metadata:)` - Create a new field
- `#name` - Field display name
- `#type` - Field type symbol
- `#id` - Unique field identifier
- `#metadata` - Custom metadata hash
- `#serializable_hash` - Convert to hash representation

### FieldValueCollection Methods

- `#values` - Get hash of all field values
- `#values=` - Set field values from hash
- `#each` - Iterate through field values (Enumerable)
- `#[](index)` - Access by array index
- `#size` / `#count` - Number of fields

## Troubleshooting

### NameError: uninitialized constant Leafy

**Solution:** Add `require 'leafy'` to your initializer file.

### Values not persisting in ActiveRecord

**Solution:** Make sure you call `save` or `save!` after setting `leafy_values`. Leafy setters update the model but don't automatically save.

### Custom converter not working

**Solution:** Ensure your converter:
1. Implements both `#dump` and `#load` as **instance methods** (not class methods)
2. Is registered before use: `Leafy.register_converter(:my_type, MyConverter.new)`
3. Handles `nil` values appropriately

### Type mismatch errors

**Solution:** Converters will attempt to coerce values. For strict validation, implement it in your converter's `#dump` or `#load` methods.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/estepnv/leafy.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
