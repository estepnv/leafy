# frozen_string_literal: true

require "spec_helper"

RSpec.describe Leafy do
  subject { described_class }

  it { is_expected.to respond_to :register_converter }

  it 'has a version number' do
    expect(subject::VERSION).not_to be nil
  end

  describe '.register_converter' do
    class TestConverter
      def dump(v); v; end
      def load(v); v; end
    end

    subject { described_class.register_converter(:test, TestConverter.new) }

    it "registers converter globally" do
      subject
      expect(described_class.converters[:test]).to be_a TestConverter
    end
  end
end
