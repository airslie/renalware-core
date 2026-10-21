module Renalware
  module ArticleHelper
    # Renders:
    # <article>
    #   <header>
    #     <h1>[title]</h1>
    #   </header>
    #   [yielded content]
    # </article>
    def article_tag(title = nil, options = nil, &)
      output = tag(:article, options, true)
      if title.present?
        output.safe_concat(
          tag.header do
            tag.h2(title)
          end
        )
      end
      output.concat(capture(&)) if block_given?
      output.safe_concat("</article>")
    end

    # Renders
    # <span>(5 of 16)</span>
    # if the supplied total exceeds the displayed count, otherwise
    # <span>(5)</span>
    def collection_count(collection, total: nil)
      return unless collection.respond_to?(:length)

      parts = ["("]
      count = collection.length
      parts.append(count)
      parts.append(" of #{total}") if total && total > count
      parts.append(")")
      tag.span(parts.join(""))
    end
  end
end
