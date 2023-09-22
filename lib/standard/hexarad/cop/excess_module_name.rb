# frozen_string_literal: true

require "rubocop"

module RuboCop::Cop
  module Hexarad
    class ExcessModuleName < RuboCop::Cop::Base
      extend RuboCop::Cop::AutoCorrector
      include RangeHelp

      MSG = "No need to specify %<module_name>s module before calling #%<method_name>s"

      def_node_matcher :module_node?, <<~PATTERN
        (send
          $(const nil? $_) $_
          ...)
      PATTERN

      def on_send(node)
        module_node?(node) do |expr, module_name, method_name|
          return unless excess?(module_name.to_s)

          add_offense(node, message: format(MSG, module_name:, method_name:)) do |corrector|
            corrector.remove(range_between(expr.loc.expression.begin_pos, expr.loc.expression.end_pos + 1))
          end
        end
      end

      private

      def excess?(module_name)
        Array(cop_config["ModuleNames"]).any? { _1 == module_name }
      end
    end
  end
end
