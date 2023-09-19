# frozen_string_literal: true

require_relative "lib/standard/hexarad/version"

Gem::Specification.new do |spec|
  spec.name = "standard-hexarad"
  spec.version = Standard::Hexarad::VERSION
  spec.authors = ["Benjamin Martin"]
  spec.email = ["benjamin247365@hotmail.com"]

  spec.summary = "plugin for standard to be used in hexarad ruby applications"
  spec.description = "plugin for standard to be used in hexarad ruby applications"
  spec.homepage = "https://github.com/hexarad/standard-hexarad"
  spec.required_ruby_version = ">= 2.6.0"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/hexarad/standard-hexarad"
  spec.metadata["changelog_uri"] = "https://github.com/hexarad/standard-hexarad"
  spec.metadata["default_lint_roller_plugin"] = "Standard::Hexarad::Plugin"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html

  spec.add_dependency "lint_roller"
  spec.add_dependency "rubocop"
end
