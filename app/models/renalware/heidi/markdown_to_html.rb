module Renalware
  module Heidi
    class MarkdownToHtml
      def initialize(markdown)
        @markdown = markdown.to_s
      end

      def call
        sanitize(blocks_to_html)
      end

      private

      attr_reader :markdown

      def blocks_to_html
        markdown
          .split(/\n{2,}/)
          .filter_map { |block| block_to_html(block.strip) }
          .join
      end

      def block_to_html(block)
        return if block.blank?

        lines = block.lines.map(&:strip)

        if unordered_list?(lines)
          list_to_html(lines, :unordered)
        elsif ordered_list?(lines)
          list_to_html(lines, :ordered)
        else
          paragraph_to_html(block)
        end
      end

      def unordered_list?(lines)
        lines.all? { |line| line.match?(/\A[-*]\s+/) }
      end

      def ordered_list?(lines)
        lines.all? { |line| line.match?(/\A\d+\.\s+/) }
      end

      def list_to_html(lines, type)
        tag = type == :ordered ? "ol" : "ul"
        items = lines.map do |line|
          content = line.sub(/\A(?:[-*]|\d+\.)\s+/, "")
          "<li>#{inline_html(content)}</li>"
        end.join

        "<#{tag}>#{items}</#{tag}>"
      end

      def paragraph_to_html(block)
        if (heading = block.match(/\A#+\s+(.+)\z/m))
          return "<p><strong>#{inline_html(heading[1])}</strong></p>"
        end

        "<p>#{inline_html(block).gsub("\n", '<br>')}</p>"
      end

      def inline_html(text)
        ERB::Util.html_escape(text)
          .gsub(/\*\*(.+?)\*\*/, '<strong>\1</strong>')
          .gsub(/__(.+?)__/, '<strong>\1</strong>')
          .gsub(/\*(.+?)\*/, '<em>\1</em>')
          .gsub(/_(.+?)_/, '<em>\1</em>')
      end

      def sanitize(html)
        ::Rails::Html::SafeListSanitizer.new.sanitize(
          html,
          tags: %w(p br ol ul li strong em),
          attributes: []
        )
      end
    end
  end
end
