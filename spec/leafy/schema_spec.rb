# frozen_string_literal: true

require "spec_helper"

RSpec.describe Leafy::Schema do
  let(:instance) {described_class.new}

  subject {instance}

  it {is_expected.to respond_to :each}
  it {is_expected.to respond_to :[]}

  it 'implemnts enumerable' do
    is_expected.to respond_to :each
    is_expected.to respond_to :to_a
    is_expected.to respond_to :find
    is_expected.to respond_to :select
  end

  describe "#push" do
    let(:field) {Leafy::Field.new(name: "Field 1", type: :dummy)}

    subject {instance << field}

    it 'adds field' do
      subject
      expect(instance.to_a[0]).to eq field
    end
  end

  describe "#[]" do
    let(:field) {Leafy::Field.new(name: "Field 1", type: :dummy, id: "id")}

    subject {instance << field; instance["id"]}

    it {is_expected.to eq field}
  end

  describe '#serializable_hash' do
    let(:field_1) {Leafy::Field.new(name: "Field 1", type: :integer, id: "id_1", metadata: {default: 1, placeholder: "enter an integer", required: true})}
    let(:field_2) {Leafy::Field.new(name: "Field 2", type: :string, id: "id_2", metadata: {default: "", placeholder: "enter value"})}
    let(:field_3) {Leafy::Field.new(name: "Field 3", type: :datetime, id: "id_3", metadata: {order: 10000})}

    subject do
      instance << field_1
      instance << field_2
      instance << field_3
      instance.serializable_hash
    end

    it 'converts schema to list of hashes' do
      is_expected.to eq([
                          {
                            :id => "id_1",
                            :name => "Field 1",
                            :type => :integer,
                            metadata: {
                              :default => 1,
                              :placeholder => "enter an integer",
                              :required => true
                            }
                          },
                          {
                            :id => "id_2",
                            :name => "Field 2",
                            :type => :string,
                            metadata: {
                              :default => "",
                              :placeholder => "enter value"
                            }
                          },
                          {
                            :id => "id_3",
                            :name => "Field 3",
                            :type => :datetime,
                            metadata: {
                              :order => 10000
                            }
                          }
        ]
        )
    end
  end

  describe ".dump" do
    let(:field_1) {Leafy::Field.new(name: "Field 1", type: "integer", id: "id_1", metadata: {default: 1, placeholder: "enter an integer", required: true})}
    let(:field_2) {Leafy::Field.new(name: "Field 2", type: "string", id: "id_2", metadata: {default: "", placeholder: "enter value"})}
    let(:field_3) {Leafy::Field.new(name: "Field 3", type: "datetime", id: "id_3", metadata: {order: 10000})}

    subject do
      instance << field_1
      instance << field_2
      instance << field_3
      described_class.dump(instance)
    end

    it 'serializes schema to JSON' do
      expected_result = JSON.parse(subject).map {|item| Leafy::Utils.symbolize_keys(item)}
      expect(expected_result).to eq(
                                   [
                                     {
                                       :id => "id_1",
                                       :metadata => {:default => 1, :placeholder => "enter an integer", :required => true},
                                       :name => "Field 1",
                                       :type => "integer"},
                                     {
                                       :id => "id_2",
                                       :metadata => {:default => "", :placeholder => "enter value"},
                                       :name => "Field 2",
                                       :type => "string"},
                                     {
                                       :id => "id_3",
                                       :metadata => {:order => 10000},
                                       :name => "Field 3",
                                       :type => "datetime"
                                     }
                                   ]
                                 )
    end
  end
end
