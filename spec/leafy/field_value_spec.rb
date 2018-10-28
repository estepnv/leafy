# frozen_string_literal: true

RSpec.describe Leafy::FieldValue do
  let(:instance) { described_class.new(id: "dummy", type: :dummy, name: "test", raw: "test") }

  subject { instance }

  it { is_expected.to respond_to :name }
  it { is_expected.to respond_to :value }
  it { is_expected.to respond_to :value= }
  it { is_expected.to respond_to :raw= }
  it { is_expected.to respond_to :raw }
  it { is_expected.to respond_to :converter= }
  it { is_expected.to respond_to :converter }
  it { is_expected.to respond_to :type= }
  it { is_expected.to respond_to :type }
end
