module Renalware
  module SnippetsHelper
    # Adds to the page:
    # - the snippets modal dialog container (which will be ajax-populated)
    # - the link to invoke the snippets dialog (loading content via ajax)
    # Note that the data-target on the modal container determines which textarea is
    # populated with when a snippet is selected.
    def snippets_modal_and_link_to_open_it(target_input_for_seleted_snippet:)
      capture do
        concat content_tag(:div,
                           nil,
                           id: "snippets-modal",
                           class: "reveal-modal",
                           data: {
                             reveal: "data-reveal",
                             target: target_input_for_seleted_snippet
                           })
        concat link_to t("snippets.insert"),
                        snippets_path(format: :js),
                        class: "button compact alternative",
                        remote: true
      end
    end
  end
end
