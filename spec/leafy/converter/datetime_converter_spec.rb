# frozen_string_literal: true

require "spec_helper"

RSpec.describe Leafy::Converter::DatetimeConverter do
  let(:instance) { described_class.new }
  subject { instance }

  it_behaves_like :loader

  it 'is transitive' do
    expect(instance.load(instance.dump(Time.new(2018, 10, 27, 23, 45, 26, "+03:00")))).to eq Time.new(2018, 10, 27, 23, 45, 26, "+03:00")
  end

  describe "#load" do
    it "returns time instance" do
      subject = instance.load("20/10/2018")

      expect(subject.month).to eq 10
      expect(subject.mday).to eq 20
      expect(subject.year).to eq 2018

      subject = instance.load("20-10-2018")

      expect(subject.month).to eq 10
      expect(subject.mday).to eq 20
      expect(subject.year).to eq 2018

      subject = instance.load("Thu Nov 29 14:33:20 GMT 2001")

      expect(subject.month).to eq 11
      expect(subject.mday).to eq 29
      expect(subject.hour).to eq 14
      expect(subject.min).to eq 33
      expect(subject.sec).to eq 20
      expect(subject.zone).to eq nil

      subject = instance.load("2018-10-27T23:45:26+03:00")
      expect(subject).to eq Time.new(2018, 10, 27, 23, 45, 26, "+03:00")
    end

    context 'when nil' do
      subject { instance.load(nil) }

      it { is_expected.to eq nil }
    end
  end

  describe "#dump" do
    subject { instance.dump(Time.new(2018, 10, 27, 23, 45, 26, "+03:00")) }

    it { is_expected.to eq "2018-10-27T23:45:26+03:00" }

    context 'when nil' do
      subject { instance.dump(nil) }

      it { is_expected.to eq nil }
    end
  end
end
