module Renalware
  module TooltipHelper

    def tooltip(label:, content:)
      content_tag(:span,
                  title: content,
                  class: "has-tip",
                  "aria-haspopup" => "true",
                  data: {
                    tooltip: "",
                    options:"disable_for_touch:true"
                    }) do
        label
      end
    end
  end
end
