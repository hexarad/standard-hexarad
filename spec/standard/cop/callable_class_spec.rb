RSpec.describe RuboCop::Cop::Hexarad::CallableClass do
  subject(:cop) { described_class.new(config) }

  let(:config) do
    RuboCop::Config.new("Hexarad/CallableClass" => {
      "Enabled" => true,
      "IgnoreClasses" => ["AllowMe"]
    })
  end

  it "finds violation to callable style" do
    expect_offense <<-RUBY
      MyClass.new.call
      ^^^^^^^^^^^^^^^^ Callable class usage for MyClass
    RUBY

    expect_correction <<-RUBY
      MyClass.call
    RUBY
  end

  it "ignored violation to callable style when on ignored class" do
    expect_no_offenses <<-RUBY
      AllowMe.new.call
    RUBY
  end

  it "finds violation to callable style when call has args" do
    expect_offense <<-RUBY
      MyClass.new.call(thing: "arg")
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Callable class usage for MyClass
    RUBY

    expect_correction <<-RUBY
      MyClass.call(thing: "arg")
    RUBY
  end

  it "finds violation to callable style when new has args" do
    expect_offense <<-RUBY
      MyClass.new(thing: "arg").call
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Callable class usage for MyClass
    RUBY

    expect_correction <<-RUBY
      MyClass.call(thing: "arg")
    RUBY
  end
end
