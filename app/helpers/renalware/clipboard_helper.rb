module Renalware
  module ClipboardHelper

    # A helper to create a clipboard.js button https://clipboardjs.com/
    def clipboard_button_for(target, width: "14rem", text: "")
      content_tag :button,
                  data: { "clipboard-action" => "copy", "clipboard-target" => target },
                  class: "clipboard-btn" do
        image_tag "clippy.svg", width: width
      end
    end
  end
end
