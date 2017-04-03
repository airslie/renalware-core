module Renalware
  module ToggleHelper
    def css_toggle_link_to(row_selector:, link_title: "Toggle")
      link_to link_title,
              "#{row_selector} .css-toggle-container",
              class: "button compact low-key",
              data: { behaviour: "css-toggler" }
    end
  end
end
