# frozen_string_literal: true

require "spec_helper"

RSpec.describe Leafy::Field do
  let(:instance) { described_class.new(type: :dummy, name: "My Field", placeholder: "1234", default: "456")}
  
  subject { instance }

  it { is_expected.to respond_to :type }
  it { is_expected.to respond_to :name }
  it { is_expected.to respond_to :id }
  it { is_expected.to respond_to :placeholder }
  it { is_expected.to respond_to :default }

  it 'stores fields' do
    expect(subject.name).to eq "My Field"
    expect(subject.type).to eq :dummy
    expect(subject.placeholder).to eq "1234"
    expect(subject.default).to eq "456"
    expect(subject.id).to  be_kind_of String
  end

  it 'accepts string keys' do
    instance = described_class.new('type' => :dummy, 'name' => "My Field", 'placeholder' => "1234", 'default' => "456")
    expect(instance).to be_a Leafy::Field
  end

  it 'has unique id' do
    threads = []
    instances = []
    30.times do
      threads << Thread.new { instances << described_class.new(type: :dummy, name: "field") }
    end
    threads.each(&:join)

    expect(instances.map(&:id).uniq.size).to eq instances.size
  end
end
