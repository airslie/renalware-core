# frozen_string_literal: true

module Renalware
  # Renders article markup with ttle and optional actions etc.
  # We use <article> extensively so this is a useful component that lets us
  # build more and more useful components. Other components can use this component
  # in their markup.
  class ArticleComponent < ApplicationComponent
    pattr_initialize [:title]
    with_content_areas :title_link, :actions
  end
end
