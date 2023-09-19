module Standard::Hexarad
  class Plugin < LintRoller::Plugin
    def initialize(config)
      @config = config
    end

    def about
      LintRoller::About.new(
        name: "standard-hexarad",
        version: VERSION,
        homepage: "https://github.com/hexarad/standard-hexarad",
        description: "Custom rules defined for Hexarad ruby applications"
      )
    end

    def supported?(context)
      true
    end

    def rules(context)
      LintRoller::Rules.new(
        type: :path,
        config_format: :rubocop,
        value: Pathname.new(__dir__).join("../../../config/base.yml")
      )
    end
  end
end
