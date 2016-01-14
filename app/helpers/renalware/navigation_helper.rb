module Renalware
  module NavigationHelper
    def sub_nav_item(label, path)
      current_page = current_page?(path)
      content_tag(:dd, class: (current_page ? "active" : "")) do
        link_to label, path
      end
    end
  end
end