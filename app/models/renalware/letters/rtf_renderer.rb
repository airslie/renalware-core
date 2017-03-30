module Renalware
  module Letters
    class RTFRenderer
      include ActionController::Rendering
      REGEX_TO_STRIP_IMAGES = %r{(?m)<img\s*.*?"\s*\/>}

      def initialize(letter, controller)
        @letter = letter
        @controller = controller
      end

      def render
        using_temp_html_file do |temp_file|
          controller.send_data rtf_content_converted_from(temp_file),
                               type: "text/richtext",
                               filename: filename
        end
      end

      private

      attr_accessor :letter, :controller

      def using_temp_html_file
        temp_html_file = Tempfile.new("html_to_be_converted_to_rtf")
        temp_html_file << html_with_images_stripped
        temp_html_file.close

        yield(temp_html_file) if block_given?

      ensure
        temp_html_file.unlink # allows garbage collection and temp file removal
      end

      def filename
        "#{letter.pdf_filename}.rtf"
      end

      def disposition
        "attachment; filename=\"#{filename}\""
      end

      def rtf_content_converted_from(html_temp_file)
        rtf_template = File.join(Rails.root, "lib", "pandoc", "templates", "default.rtf")
        options = { template: rtf_template }
        PandocRuby.html([html_temp_file.path], options, :standalone).to_rtf
      end

      def html_with_images_stripped
        @html ||= begin
          controller.render_to_string(
            template: "/renalware/letters/formatted_letters/show.html",
            layout: "renalware/layouts/letter.html",
            locals: { letter: letter }
          ).gsub!(REGEX_TO_STRIP_IMAGES, "")
        end
      end
    end
  end
end
