# frozen_string_literal: true

module Renalware
  module Snippeting
    module SnippetsHelper
      # Adds to the page:
      # - the snippets modal dialog container (which will be ajax-populated)
      # - the link to invoke the snippets dialog (loading content via ajax)
      # Note that the data-target on the modal container determines which textarea is
      # populated with when a snippet is selected.
      # rubocop:disable Metrics/MethodLength
      def snippets_modal_and_link_to_open_it(target_input_for_selected_snippet:)
        capture do
          concat tag.div(nil,
                         id: "snippets-modal",
                         class: "reveal-modal",
                         data: {
                           reveal: "data-reveal",
                           controller: "snippets",
                           "snippets-target-input" => target_input_for_selected_snippet,
                           target: target_input_for_selected_snippet
                         })
          concat link_to t("snippets.insert"),
                         snippeting.snippets_path(format: :js),
                         class: "button alternative right insert-snippet-button",
                         remote: true
        end
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
