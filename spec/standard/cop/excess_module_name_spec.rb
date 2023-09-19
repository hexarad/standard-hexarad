RSpec.describe RuboCop::Cop::Hexarad::ExcessModuleName do
  subject(:cop) { described_class.new(config) }

  let(:config) do
    RuboCop::Config.new("Hexarad/ExcessModuleName" => {
      "Enabled" => true,
      "ModuleNames" => ["FactoryBot"]
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

  it "finds excess module names" do
    assert_offense cop, <<-RUBY
      FactoryBot.create(:something, other: FactoryBot.build(:other))
                                           ^^^^^^^^^^^^^^^^^^^^^^^^ No need to specify FactoryBot module before calling #build
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ No need to specify FactoryBot module before calling #create
    RUBY

    assert_correction cop, <<-RUBY
      create(:something, other: build(:other))
    RUBY
  end
end
