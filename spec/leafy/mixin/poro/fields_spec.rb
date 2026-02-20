require "spec_helper"

require "leafy/mixin/poro/fields"

RSpec.describe Leafy::Mixin::Poro::Fields do
  before do
    class FieldsHost
      include Leafy::Mixin::Fields[:poro]

      attr_accessor :leafy_data

      def leafy_fields
        field_1 = Leafy::Field.new(name: "Field 1", type: :integer, id: "id_1", default: 1, placeholder: "enter an integer", required: true)
        field_2 = Leafy::Field.new(name: "Field 2", type: :string, id: "id_2", default: "", placeholder: "enter value")
        field_3 = Leafy::Field.new(name: "Field 3", type: :datetime, id: "id_3", order: 10000)

        schema = Leafy::Schema.new
        schema << field_1
        schema << field_2
        schema << field_3

        schema
      end
    end
  end

  after do
    Object.send(:remove_const, "FieldsHost") if Object.const_defined?("FieldsHost")
  end

  let(:instance) { FieldsHost.new }
  subject { instance }

  it { is_expected.to respond_to :leafy_values }
  it { is_expected.to respond_to :leafy_field_values}

  describe "#Leafy_values" do
    it 'returns values hash' do
      instance.leafy_data = JSON.dump({ "id_1": "1", "id_2": "test", "id_3": Time.new(2018,10,10, 10,10,10, "+03:00").iso8601 })

      field_values = instance.leafy_values

      expect(field_values.size).to eq 3
      expect(field_values["id_1"]).to eq 1
      expect(field_values["id_2"]).to eq "test"
      expect(field_values["id_3"]).to eq Time.new(2018,10,10, 10,10,10, "+03:00")
    end
  end

  describe '#Leafy_values=' do
    it 'sets values hash' do
      instance.leafy_values = { "id_1": 123, "id_2": "test", "id_3": Time.new(2018,10,10, 10,10,10, "+03:00") }

      field_values = instance.leafy_values

      expect(field_values.size).to eq 3
      expect(field_values["id_1"]).to eq 123
      expect(field_values["id_2"]).to eq "test"
      expect(field_values["id_3"]).to eq Time.new(2018,10,10, 10,10,10, "+03:00")

      expect(instance.leafy_data).to eq  "{\"id_1\":\"123\",\"id_2\":\"test\",\"id_3\":\"2018-10-10T07:10:10Z\"}"
    end
  end

  describe "#leafy_field_values" do

    it 'returns leafy::FieldValue list' do
      field_values = instance.leafy_field_values

      expect(field_values.size).to eq 3
      expect(field_values[0].value).to eq nil
      expect(field_values[1].value).to eq nil
      expect(field_values[2].value).to eq nil

      instance.leafy_data = JSON.dump({ id_1: "1" })

      field_values = instance.leafy_field_values

      expect(field_values.size).to eq 3
      expect(field_values[0].value).to eq 1
      expect(field_values[1].value).to eq nil
      expect(field_values[2].value).to eq nil

      instance.leafy_data = JSON.dump({ id_1: "1", id_2: "test" })

      field_values = instance.leafy_field_values

      expect(field_values.size).to eq 3
      expect(field_values[0].value).to eq 1
      expect(field_values[1].value).to eq "test"
      expect(field_values[2].value).to eq nil

      instance.leafy_data = JSON.dump({ id_1: "1", id_2: "test", id_3: Time.new(2018,10,10, 10,10,10, "+03:00").iso8601 })

      field_values = instance.leafy_field_values

      expect(field_values.size).to eq 3
      expect(field_values[0].value).to eq 1
      expect(field_values[1].value).to eq "test"
      expect(field_values[2].value).to eq Time.new(2018,10,10, 10,10,10, "+03:00")

    end
  end
end
