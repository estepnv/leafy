# frozen_string_literal: true

require "spec_helper"

RSpec.describe Leafy::Field do
  let(:instance) { described_class.new(type: :dummy, name: "My Field", metadata: { placeholder: "1234", default: "456" }) }

  subject { instance }

  it { is_expected.to respond_to :type }
  it { is_expected.to respond_to :name }
  it { is_expected.to respond_to :id }
  it { is_expected.to respond_to :metadata }

  it 'stores fields' do
    expect(subject.name).to eq "My Field"
    expect(subject.type).to eq :dummy
    expect(subject.metadata[:placeholder]).to eq "1234"
    expect(subject.metadata[:default]).to eq "456"
    expect(subject.id).to  be_kind_of String
  end

  it 'accepts string keys' do
    instance = described_class.new('type' => :dummy, 'name' => "My Field", 'placeholder' => "1234", 'default' => "456")
    expect(instance).to be_a Leafy::Field
  end
end
