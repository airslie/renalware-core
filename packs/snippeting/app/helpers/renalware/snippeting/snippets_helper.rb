# frozen_string_literal: true

module Renalware
  module Snippeting
    module SnippetsHelper
      # TODO: handle insertion of snippet correctly
      # rubocop:disable Lint/UnusedMethodArgument
      def snippets_modal_and_link_to_open_it(target_input_for_selected_snippet:)
        link_to t("snippets.insert"),
                snippeting.snippets_path,
                class: :button,
                data: { turbo: true, turbo_frame: "modal" }
      end
      # rubocop:enable Lint/UnusedMethodArgument
    end
  end
end
