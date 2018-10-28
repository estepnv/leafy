# frozen_string_literal: true

require "spec_helper"

RSpec.describe Leafy::Converter::IntegerConverter do
  let(:instance) { described_class.new }
  
  it_behaves_like :loader
  
  it 'is transitive' do
    expect(instance.load(instance.dump(12345))).to eq 12345
  end

  describe "#load" do
    context 'when nil' do
      subject { instance.load(nil) }

      it { is_expected.to eq nil }
    end

    context 'when string' do
      subject { instance.load("12345") }

      it { is_expected.to eq 12345 }
    end

    context 'when number' do
      subject { instance.load(12345) }

      it { is_expected.to eq 12345 }
    end
  end

  describe "#dump" do
    subject { instance.dump(12345) }

    it { is_expected.to eq "12345" }

    context 'when nil' do
      subject { instance.dump(nil) }

      it { is_expected.to eq nil }
    end
  end
end
