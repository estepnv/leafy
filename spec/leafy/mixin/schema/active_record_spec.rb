require "spec_helper"
require "active_record"

RSpec.describe Leafy::Mixin::Schema::ActiveRecord do

  let(:schema_host_class) do
    Class.new(::ActiveRecord::Base) do
      include Leafy::Mixin::Schema[:active_record]
      self.table_name = :schema_hosts
      self.leafy_data_attribute = :leafy_data

      attr_accessor :leafy_data
    end
  end

  before do
    ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
    ActiveRecord::Base.connection.create_table(:schema_hosts) do |t|
      t.text :leafy_data
      t.timestamps
    end
    ActiveRecord::Base.raise_in_transactional_callbacks = true unless ActiveRecord.version >= Gem::Version.new("5.0.0")
  end

  after { ActiveRecord::Base.remove_connection }

  subject { schema_host_class.new }

  it { is_expected.to respond_to :leafy_data }
  it { is_expected.to respond_to :leafy_fields }
  it { is_expected.to respond_to :leafy_fields_attributes= }

  it "accepts custom attributes" do
    subject.leafy_fields_attributes = [
      { type: :integer, name: "My Number", id: "id_1" },
      { type: :string, name: "My String", id: "id_2" }
    ]
    expect(subject.leafy_data).to eq "[{\"name\":\"My Number\",\"type\":\"integer\",\"id\":\"id_1\",\"metadata\":{}},{\"name\":\"My String\",\"type\":\"string\",\"id\":\"id_2\",\"metadata\":{}}]"

    subject.save!

    custom_fields_arr = subject.reload.leafy_fields.to_a

    expect(subject.leafy_fields).to be_a Leafy::Schema

    integer_field = custom_fields_arr[0]
    expect(integer_field).to be_a Leafy::Field
    expect(integer_field.type).to eq :integer
    expect(integer_field.name).to eq "My Number"

    string_field = custom_fields_arr[1]
    expect(string_field).to be_a Leafy::Field
    expect(string_field.type).to eq :string
    expect(string_field.name).to eq "My String"
  end
end
