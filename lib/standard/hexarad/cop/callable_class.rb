# frozen_string_literal: true

module RuboCop::Cop
  module Hexarad
    class CallableClass < RuboCop::Cop::Base
      extend RuboCop::Cop::AutoCorrector
      include RangeHelp

      MSG = "Callable class usage for %<class_name>s"
      def_node_matcher :callable_class, <<~PATTERN
        (send $(send _ :new) :call ...)
      PATTERN

      def on_send(node)
        callable_class(node) do |expr|
          class_name = "Todo"
          add_offense(node, message: format(MSG, class_name:)) do |corrector|
            corrector.remove(
              range_between(
                expr.loc.expression.end_pos - 4,
                expr.loc.expression.end_pos
              )
            )
          end
        end
      end

      private

      def ignore_classes = Array(cop_config["IgnoreClasses"])
    end
  end
end
