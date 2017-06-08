module Renalware
  module DropdownButtonHelper

    def dropdown_btn_item(enabled: true, title:, path:)
      content_tag(:li, class: "#{'disabled' unless enabled}") do
        link_to_if(enabled, title, path)
      end
    end
  end
end
