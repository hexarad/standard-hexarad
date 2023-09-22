RSpec.describe RuboCop::Cop::Hexarad::ExcessModuleName do
  subject(:cop) { described_class.new(config) }

  let(:config) do
    RuboCop::Config.new("Hexarad/ExcessModuleName" => {
      "Enabled" => true,
      "ModuleNames" => ["FactoryBot"]
    })
  end

  it "finds excess module names" do
    expect_offense <<-RUBY
      FactoryBot.create(:something)
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ No need to specify FactoryBot module before calling #create
    RUBY

    expect_correction <<-RUBY
      create(:something)
    RUBY
  end

  it "finds excess module names when nested on the same line" do
    expect_offense <<-RUBY
      FactoryBot.create(:something, other: FactoryBot.build(:other))
                                           ^^^^^^^^^^^^^^^^^^^^^^^^ No need to specify FactoryBot module before calling #build
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ No need to specify FactoryBot module before calling #create
    RUBY

    expect_correction <<-RUBY
      create(:something, other: build(:other))
    RUBY
  end

  it "finds excess module names and only fix that problem" do
    expect_offense <<-RUBY
      FactoryBot.build("FactoryBot.build")
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ No need to specify FactoryBot module before calling #build
    RUBY

    expect_correction <<-RUBY
      build("FactoryBot.build")
    RUBY
  end

  it "finds excess module names when being assigned" do
    expect_offense <<-RUBY
      thing = FactoryBot.build(:thing)
              ^^^^^^^^^^^^^^^^^^^^^^^^ No need to specify FactoryBot module before calling #build
    RUBY

    expect_correction <<-RUBY
      thing = build(:thing)
    RUBY
  end
end
