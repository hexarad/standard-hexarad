# frozen_string_literal: true

module RuboCop::Cop
  module Hexarad
    class CallableClass < RuboCop::Cop::Base
      extend RuboCop::Cop::AutoCorrector
      include RangeHelp

      MSG = "Callable class usage for %<class_name>s"
      def_node_matcher :callable_class, <<~PATTERN
        (send $(send $_ :new) :call ...)
      PATTERN

      def_node_matcher :callable_class_with_new_args, <<~PATTERN
        (send $(send $_ :new $(...)) :call)
      PATTERN

      def on_send(node)
        callable_class(node) do |expr, expr2|
          class_name = expr2.short_name.to_s
          return if ignore_class?(class_name)

          add_offense(node, message: format(MSG, class_name:)) do |corrector|
            corrector.remove(
              range_between(
                expr.loc.expression.end_pos - 4,
                expr.loc.expression.end_pos
              )
            )
          end
        end

        callable_class_with_new_args(node) do |expr, expr2, expr3|
          class_name = expr2.short_name.to_s
          return if ignore_class?(class_name)

          add_offense(node, message: format(MSG, class_name:)) do |corrector|
            corrector.replace(expr.loc.expression, "#{class_name}.call(#{expr3.source})")
            corrector.remove(
              range_between(
                node.loc.expression.end_pos - 5,
                node.loc.expression.end_pos
              )
            )
          end
        end
      end

      private

      def ignore_class?(class_name)
        ignore_classes.any? { _1 == class_name }
      end

      def ignore_classes = Array(cop_config["IgnoreClasses"])
    end
  end
end
