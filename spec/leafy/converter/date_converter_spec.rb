# frozen_string_literal: true

require "spec_helper"
require "time"

RSpec.describe Leafy::Converter::DateConverter do
  let(:instance) { described_class.new }
  subject { instance }

  it_behaves_like :loader

  it 'is transitive' do
    expect(instance.load(instance.dump(Date.new(2018, 10, 27)))).to eq Date.new(2018, 10, 27)
  end

  describe "#load" do
    it "returns time instance" do
      expect(instance.load("2018-10-27")).to eq Date.new(2018, 10, 27)
      expect(instance.load(nil)).to eq nil
    end
  end

  describe "#dump" do
    it 'converts time to iso8601 time string' do
      expect(instance.dump(Time.new(2018, 10, 27, 23, 45, 26, "+04:00"))).to eq "2018-10-27"
      expect(instance.dump(Time.new(2018, 10, 27))).to eq "2018-10-27"
      expect(instance.dump(Date.new(2018, 10, 27))).to eq "2018-10-27"
      expect(instance.dump(nil)).to eq nil
    end
  end
end
