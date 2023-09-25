# frozen_string_literal: true

require "lint_roller"

module Standard
  module Hexarad
  end
end

require "rubocop"
require_relative "hexarad/cop/excess_module_name"
require_relative "hexarad/cop/callable_class"
require_relative "hexarad/version"
require_relative "hexarad/plugin"
