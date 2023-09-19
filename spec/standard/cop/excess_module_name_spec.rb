RSpec.describe RuboCop::Cop::Hexarad::ExcessModuleName do
  subject(:cop) { described_class.new(config) }

  let(:config) do
    RuboCop::Config.new("ExcessModuleName" => {
      "Enabled" => true
    })
  end

  include CopInvoker

  it "finds excess module names" do
    assert_offense cop, <<-RUBY
      FactoryBot.create(:something)
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ No need to specify FactoryBot module before calling #create
    RUBY

    assert_correction cop, <<-RUBY
      create(:something)
    RUBY
  end
end
