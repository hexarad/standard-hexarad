# frozen_string_literal: true

require "rubocop"

module RuboCop::Cop
  module Hexarad
    class ExcessModuleName < RuboCop::Cop::Base
      extend RuboCop::Cop::AutoCorrector
      include IgnoredNode

      def on_send(node)
        return unless node.receiver&.const_type?

        module_name = node.receiver.const_name.to_s
        return unless excess?(module_name)

        method_name = node.method_name.to_s
        msg = "No need to specify #{module_name} module before calling ##{method_name}"
        add_offense(node, message: msg) do |corrector|
          next if part_of_ignored_node?(node)

          autocorrect(corrector, node, module_name)
        end

        ignore_node(node)
      end

      private

      def excess?(module_name)
        Array(cop_config["ModuleNames"]).any? { _1 == module_name }
      end

      def autocorrect(corrector, node, module_name)
        corrector.replace(node, node.source.gsub("#{module_name}.", ""))
      end
    end
  end
end
