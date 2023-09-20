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

  it "finds excess module names when nested on the same line" do
    assert_offense cop, <<-RUBY
      FactoryBot.create(:something, other: FactoryBot.build(:other))
                                           ^^^^^^^^^^^^^^^^^^^^^^^^ No need to specify FactoryBot module before calling #build
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ No need to specify FactoryBot module before calling #create
    RUBY

    assert_correction cop, <<-RUBY
      create(:something, other: build(:other))
    RUBY
  end

  it "finds excess module names and only fix that problem" do
    assert_offense cop, <<-RUBY
      FactoryBot.build("FactoryBot.build")
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ No need to specify FactoryBot module before calling #build
    RUBY

    assert_correction cop, <<-RUBY
      build("FactoryBot.build")
    RUBY
  end
end
