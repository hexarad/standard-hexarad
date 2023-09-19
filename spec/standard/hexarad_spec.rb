# frozen_string_literal: true

RSpec.describe Standard::Hexarad do
  it "has a version number" do
    expect(Standard::Hexarad::VERSION).not_to be nil
  end

  let(:base_config) { "config/base.yml" }

  it "configures all custom cops" do
    Dir[Pathname.new(__dir__).join("../../lib/standard/cop/*")].sort.each { |file| require file }
    expected = RuboCop::Cop::Hexarad.constants.map { |name| "Hexarad/#{name}" }
    actual = YAML.load_file(base_config).keys

    missing = expected - actual
    extra = actual - expected

    # Configure these cops as either Enabled: true or Enabled: false in #{BASE_CONFIG}"
    expect(missing).to eq []

    # These cops do not exist and should not be configured in #{BASE_CONFIG}"
    expect(extra).to eq []
  end
end
