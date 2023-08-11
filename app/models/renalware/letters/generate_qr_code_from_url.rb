# frozen_string_literal: true

module Renalware
  module Letters
    # Given a hyperlink to say an article, guide or app to download, render the url to a QR Code
    # for inclusion in a letter.
    class GenerateQRCodeFromUrl
      DEFAULT_MODULE_SIZE = 5 # The pixel size of each module - determines the size on the letter
      DEFAULT_ERROR_CORRECTION = :m # 15% of code can be restored
      pattr_initialize :url

      def self.call(url, **opts)
        new(url).call(**opts)
      end

      def call(**opts)
        format = opts.delete(:format) || :svg
        case format
        when :png then png(**opts)
        else svg(**opts)
        end
      end

      private

      def svg(**opts)
        RQRCode::QRCode.new(url, level: DEFAULT_ERROR_CORRECTION).as_svg(
          {
            color: "333",
            shape_rendering: "crispEdges",
            module_size: DEFAULT_MODULE_SIZE,
            standalone: true,
            use_path: true,
            viewbox: true # means we have to explictly add a width using css
          }.merge(**opts)
        )
      end

      def png(**opts)
        RQRCode::QRCode.new(url, level: DEFAULT_ERROR_CORRECTION).as_png(
          {
            size: 120,
            border_modules: 0,
            color: "#333"
          }.merge(**opts)
        )
      end
    end
  end
end
