# frozen_string_literal: true

require "spec_helper"

RSpec.describe Leafy::Converter::DummyConverter do
  let(:instance) { described_class.new }
  subject {instance }

  it_behaves_like :loader

end
