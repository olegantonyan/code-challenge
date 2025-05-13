require 'spec_helper'
require 'json'

describe ::GoogleArtwork do
  subject do
    ::JSON.pretty_generate(described_class.parse(load_test_html).serialize)
  end

  it { is_expected.to eq(load_test_output) }
end
