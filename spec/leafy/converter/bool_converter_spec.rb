# frozen_string_literal: true

require "spec_helper"

RSpec.describe Leafy::Converter::BoolConverter do
  let(:instance) { described_class.new }
  subject {instance }

  it_behaves_like :loader

  it 'is transitive' do
    expect(instance.load(instance.dump(true))).to eq true
  end

  describe "#dump" do
    it "converts boolean values" do
      subject = instance.dump(true)
      expect(subject).to eq "1"
      subject = instance.dump(false)
      expect(subject).to eq "0"
    end
  end

  describe "#load" do
    it "converts boolean values" do
      subject = instance.load("true")
      expect(subject).to eq true
      subject = instance.load("1")
      expect(subject).to eq true
      subject = instance.load("t")
      expect(subject).to eq true
      subject = instance.load("yes")
      expect(subject).to eq true
      subject = instance.load("y")
      expect(subject).to eq true

      subject = instance.load("false")
      expect(subject).to eq false
      subject = instance.load("0")
      expect(subject).to eq false
      subject = instance.load("no")
      expect(subject).to eq false
      subject = instance.load("n")
      expect(subject).to eq false
      subject = instance.load("f")
      expect(subject).to eq false
      subject = instance.load(0)
      expect(subject).to eq false
      subject = instance.load(nil)
      expect(subject).to eq nil
    end
  end

end
