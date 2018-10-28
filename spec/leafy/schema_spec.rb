# frozen_string_literal: true

require "spec_helper"

RSpec.describe Leafy::Schema do
  let(:instance) { described_class.new }
  
  subject { instance }
  
  it { is_expected.to respond_to :each }
  it { is_expected.to respond_to :[] }

  it 'implemnts enumerable' do
    is_expected.to respond_to :each
    is_expected.to respond_to :to_a
    is_expected.to respond_to :find
    is_expected.to respond_to :select
  end

  describe "#push" do
    let(:field) { Leafy::Field.new(name: "Field 1", type: :dummy) }

    subject { instance << field }

    it 'adds field' do
      subject
      expect(instance.to_a[0]).to eq field
    end
  end

  describe "#[]" do
    let(:field) { Leafy::Field.new(name: "Field 1", type: :dummy, id: "id") }

    subject { instance << field; instance["id"] }

    it { is_expected.to eq field }
  end

  describe '#serializable_hash' do
    let(:field_1) { Leafy::Field.new(name: "Field 1", type: :integer, id: "id_1", default: 1, placeholder: "enter an integer", required: true) }
    let(:field_2) { Leafy::Field.new(name: "Field 2", type: :string, id: "id_2", default: "", placeholder: "enter value") }
    let(:field_3) { Leafy::Field.new(name: "Field 3", type: :datetime, id: "id_3", order: 10000) }

    subject do
      instance << field_1
      instance << field_2
      instance << field_3
      instance.serializable_hash
    end

    it 'converts schema to list of hashes' do
      is_expected.to eq(
        [
          {:default=>1,
            :hidden=>false,
            :id=>"id_1",
            :name=>"Field 1",
            :order=>0,
            :placeholder=>"enter an integer",
            :readonly=>false,
            :required=>true,
            :type=>:integer},
           {:default=>"",
            :hidden=>false,
            :id=>"id_2",
            :name=>"Field 2",
            :order=>0,
            :placeholder=>"enter value",
            :readonly=>false,
            :required=>false,
            :type=>:string},
           {:default=>nil,
            :hidden=>false,
            :id=>"id_3",
            :name=>"Field 3",
            :order=>10000,
            :placeholder=>nil,
            :readonly=>false,
            :required=>false,
            :type=>:datetime}
          ]
      )
    end
  end

  describe ".dump" do
    let(:field_1) { Leafy::Field.new(name: "Field 1", type: :integer, id: "id_1", default: 1, placeholder: "enter an integer", required: true) }
    let(:field_2) { Leafy::Field.new(name: "Field 2", type: :string, id: "id_2", default: "", placeholder: "enter value") }
    let(:field_3) { Leafy::Field.new(name: "Field 3", type: :datetime, id: "id_3", order: 10000) }

    subject do
      instance << field_1
      instance << field_2
      instance << field_3
      described_class.dump(instance)
    end

    it 'serializes schema to JSON' do
      expect(subject).to eq "[{\"name\":\"Field 1\",\"type\":\"integer\",\"id\":\"id_1\",\"placeholder\":\"enter an integer\",\"default\":1,\"required\":true,\"readonly\":false,\"hidden\":false,\"order\":0},{\"name\":\"Field 2\",\"type\":\"string\",\"id\":\"id_2\",\"placeholder\":\"enter value\",\"default\":\"\",\"required\":false,\"readonly\":false,\"hidden\":false,\"order\":0},{\"name\":\"Field 3\",\"type\":\"datetime\",\"id\":\"id_3\",\"placeholder\":null,\"default\":null,\"required\":false,\"readonly\":false,\"hidden\":false,\"order\":10000}]"
    end
  end
end
