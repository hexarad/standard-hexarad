# frozen_string_literal: true

require "rubocop"

module RuboCop::Cop
  module Hexarad
    class ExcessModuleName < RuboCop::Cop::Base
      extend RuboCop::Cop::AutoCorrector

      def on_send(node)
        return unless node.receiver&.const_type?

        module_name = node.receiver.const_name.to_s
        return unless excess?(module_name)

        method_name = node.method_name.to_s
        msg = "No need to specify #{module_name} module before calling ##{method_name}"
        add_offense(node, message: msg) do |corrector|
          autocorrect(corrector, node, module_name)
        end
      end

      private

      EXCESS_MODULE_NAME = "FactoryBot"
      private_constant :EXCESS_MODULE_NAME

      def excess?(module_name)
        module_name == EXCESS_MODULE_NAME
      end

      def autocorrect(corrector, node, module_name)
        corrector.replace(node, node.source.sub("#{module_name}.", ""))
      end
    end
  end
end
