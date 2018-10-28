require "spec_helper"

class SchemaHost
  include Leafy::Mixin::Schema[:poro]

  attr_accessor :leafy_data
end

RSpec.describe SchemaHost do
  subject { described_class.new }

  it { is_expected.to respond_to :leafy_fields }
  it { is_expected.to respond_to :leafy_fields_attributes= }

  it "accepts custom attributes" do
    subject.leafy_fields_attributes = [
      { type: :integer, name: "My Number", id: "id_1" },
      { type: :string, name: "My String", id: "id_2" }
    ]
    expect(subject.leafy_data).to eq "[{\"name\":\"My Number\",\"type\":\"integer\",\"id\":\"id_1\",\"placeholder\":null,\"default\":null,\"required\":false,\"readonly\":false,\"hidden\":false,\"order\":0},{\"name\":\"My String\",\"type\":\"string\",\"id\":\"id_2\",\"placeholder\":null,\"default\":null,\"required\":false,\"readonly\":false,\"hidden\":false,\"order\":0}]"

    custom_fields_arr = subject.leafy_fields.to_a

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
