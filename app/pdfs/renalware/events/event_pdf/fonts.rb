module Renalware
  module Events
    class EventPdf
      module Fonts
        def self.configure(document)
          font_path = Rails.root.join("lib/fonts/dejavu")
          document.font_families.update(
            "DejaVuSans" => {
              normal: { file: font_path.join("DejaVuSans.ttf"), subset: true },
              bold: { file: font_path.join("DejaVuSans-Bold.ttf"), subset: true },
              italic: { file: font_path.join("DejaVuSans-Oblique.ttf"), subset: true },
              bold_italic: { file: font_path.join("DejaVuSans-BoldOblique.ttf"), subset: true }
            }
          )
          # Keep Helvetica for supported text; embed only the fallback glyphs that are used.
          document.fallback_fonts = ["DejaVuSans"]
        end
      end
    end
  end
end
