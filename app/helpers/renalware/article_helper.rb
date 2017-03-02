module Renalware
  module ArticleHelper
    # Renders:
    # <article>
    #   <header>
    #     <h1>[title]</h1>
    #   </header>
    #   [yielded content]
    # </article>
    def article_tag(title = nil, options = nil, &block)
      output = tag(:article, options, true)
      unless title.blank?
        output.safe_concat(
          content_tag("header".freeze) do
            content_tag("h1".freeze, title)
          end
          )
      end
      output.concat(capture(&block)) if block_given?
      output.safe_concat("</article>")
    end
  end
end
