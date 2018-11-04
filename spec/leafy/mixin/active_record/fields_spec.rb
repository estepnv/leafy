require "spec_helper"
require "leafy/mixin/active_record/schema"
require "leafy/mixin/active_record/fields"
require "active_record"

RSpec.describe Leafy::Mixin::ActiveRecord::Fields do

  before do
    class SchemaHost < ActiveRecord::Base
      include Leafy::Mixin::Schema[:active_record]

      self.table_name = :schema_hosts
      self.leafy_data_attribute = :leafy_data
    end

    class FieldsHost < ActiveRecord::Base
      include Leafy::Mixin::Fields[:active_record]

      self.table_name = :fields_hosts
      self.leafy_data_attribute = :leafy_data

      belongs_to :schema_host, required: true

      delegate :leafy_fields, to: :schema_host
    end

    ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

    ActiveRecord::Base.connection.create_table(:schema_hosts, force: true) do |t|
      t.text :leafy_data
      t.timestamps
    end

    ActiveRecord::Base.connection.create_table(:fields_hosts) do |t|
      t.belongs_to :schema_host, required: true
      t.text :leafy_data
      t.timestamps
    end

    ActiveRecord::Base.raise_in_transactional_callbacks = true unless ActiveRecord.version >= Gem::Version.new("5.0.0")
  end

  after do
    ActiveRecord::Base.remove_connection
    Object.send(:remove_const, "SchemaHost")
    Object.send(:remove_const, "FieldsHost")
  end

  let(:instance) do
    host_instace = SchemaHost.create!(
      leafy_fields_attributes: [
        { name: "Field 1", type: :integer, id: "id_1", metadata: { default: 1, placeholder: "enter an integer", required: true } },
        { name: "Field 2", type: :string, id: "id_2", metadata: { default: "", placeholder: "enter value" } },
        { name: "Field 3", type: :datetime, id: "id_3", metadata: { order: 10000 } }
      ]
    )

    FieldsHost.create(schema_host: host_instace)
  end

  subject { instance }

  it { is_expected.to respond_to :leafy_values }
  it { is_expected.to respond_to :leafy_field_values}

  describe "#leafy_values" do
    it 'returns values hash' do
      instance.leafy_data = JSON.dump({ "id_1": "1", "id_2": "test", "id_3": Time.new(2018,10,10, 10,10,10, "+03:00").iso8601 })
      instance.save!
      instance.reload

      field_values = instance.leafy_values

      expect(field_values.size).to eq 3
      expect(field_values["id_1"]).to eq 1
      expect(field_values["id_2"]).to eq "test"
      expect(field_values["id_3"]).to eq Time.new(2018,10,10, 10,10,10, "+03:00")
    end
  end

  describe '#leafy_values=' do
    it 'sets values hash' do
      instance.leafy_values = { "id_1": 123, "id_2": "test", "id_3": Time.new(2018,10,10, 10,10,10, "+03:00") }
      instance.save!
      instance.reload

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
      instance.save!
      instance.reload

      expect(field_values.size).to eq 3
      expect(field_values[0].value).to eq nil
      expect(field_values[1].value).to eq nil
      expect(field_values[2].value).to eq nil

      instance.leafy_data = JSON.dump({ id_1: "1" })
      instance.save!
      instance.reload

      field_values = instance.leafy_field_values

      expect(field_values.size).to eq 3
      expect(field_values[0].value).to eq 1
      expect(field_values[1].value).to eq nil
      expect(field_values[2].value).to eq nil

      instance.leafy_data = JSON.dump({ id_1: "1", id_2: "test" })
      instance.save!
      instance.reload

      field_values = instance.leafy_field_values

      expect(field_values.size).to eq 3
      expect(field_values[0].value).to eq 1
      expect(field_values[1].value).to eq "test"
      expect(field_values[2].value).to eq nil

      instance.leafy_data = JSON.dump({ id_1: "1", id_2: "test", id_3: Time.new(2018,10,10, 10,10,10, "+03:00").iso8601 })
      instance.save!
      instance.reload

      field_values = instance.leafy_field_values

      expect(field_values.size).to eq 3
      expect(field_values[0].value).to eq 1
      expect(field_values[1].value).to eq "test"
      expect(field_values[2].value).to eq Time.new(2018,10,10, 10,10,10, "+03:00")

    end
  end
end
