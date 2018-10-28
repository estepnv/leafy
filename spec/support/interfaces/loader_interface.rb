# frozen_string_literal: true

RSpec.shared_examples :loader do
  it { is_expected.to respond_to :dump }
  it { is_expected.to respond_to :load }
end
