# frozen_string_literal: true

require "spec_helper"
require "time"

RSpec.describe Leafy::Converter::DatetimeConverter do
  let(:instance) { described_class.new }
  subject { instance }

  it_behaves_like :loader

  it 'is transitive' do
    expect(instance.load(instance.dump(Time.new(2018, 10, 27, 23, 45, 26, "+03:00")))).to eq Time.new(2018, 10, 27, 23, 45, 26, "+03:00")
  end

  describe "#load" do
    it "returns time instance" do
      expect(instance.load("2018-10-27T23:45:26Z")).to eq Time.new(2018, 10, 27, 23, 45, 26, "+00:00")
      expect(instance.load(nil)).to eq nil
    end
  end

  describe "#dump" do
    it 'converts time to iso8601 time string' do
      expect(instance.dump(Time.new(2018, 10, 27, 23, 45, 26, "+04:00"))).to eq "2018-10-27T19:45:26Z"
      expect(instance.dump(Time.new(2018, 10, 27, nil, nil, nil, "+03:00"))).to eq "2018-10-26T21:00:00Z"
      expect(instance.dump(nil)).to eq nil
    end
  end
end
