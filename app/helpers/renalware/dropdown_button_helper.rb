module Renalware
  module DropdownButtonHelper
    def dropdown_btn_item(enabled: true, title:, path:)
      content_tag(:li, class: "#{'disabled' unless enabled}") do
        link_to_if(enabled, title, path)
      end
    end

    # rubocop:disable Metrics/MethodLength
    def dropdown_btn_icon_link(enabled: true, icon:, title:, path:, **options)
      content_tag(:li, class: "#{'disabled' unless enabled}") do
        capture do
          if enabled
            capture do
              link_to(path, options) do
                concat "<i class='fa fa-link-annotation #{icon}'></i>".html_safe
                concat title
              end
            end
          else
            capture do
              concat "<i class='fa fa-link-annotation #{icon}'></i>".html_safe
              concat title
            end
          end
        end
      end
    end
    # rubocop:enable Metrics/MethodLength
  end
end
