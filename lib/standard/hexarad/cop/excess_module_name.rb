# frozen_string_literal: true

require "rubocop"

module RuboCop::Cop
  module Hexarad
    class ExcessModuleName < RuboCop::Cop::Base
      extend RuboCop::Cop::AutoCorrector
      include RangeHelp

      MSG = "No need to specify %<module_name>s module before calling #%<method_name>s"

      def on_send(node)
        each_excess_module_name(node) do |expr, module_name, method_name|
          add_offense(node, message: format(MSG, module_name:, method_name:)) do |corrector|
            corrector.remove(range_between(expr.loc.expression.begin_pos, expr.loc.expression.end_pos + 1))
          end
        end
      end

      private

      def each_excess_module_name(node, &block)
        excess_module_names.each do |module_name|
          matcher_name = "excess_#{module_name}?".to_sym
          unless respond_to?(matcher_name)
            pattern = "(send $(const nil? $:#{module_name}) $_ ...)"
            self.class.def_node_matcher(matcher_name, pattern)
          end
          public_send(matcher_name, node, &block)
        end
      end

      def excess_module_names = Array(cop_config["ModuleNames"])
    end
  end
end
