# frozen_string_literal: true

module ElementHelpers
  def within_article(title)
    within(:css, "article", text: title) do
      yield
    end
  end
end

World(ElementHelpers)
