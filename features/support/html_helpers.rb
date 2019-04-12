# frozen_string_literal: true

module HTMLHelpers
  # rubocop:disable Rails/DynamicFindBy
  def html_table_to_array(dom_id)
    find_by_id(dom_id)
      .all("tr")
      .map do |row|
        row.all("th, td").map { |cell| cell.text.strip }
      end
  end
  # rubocop:enable Rails/DynamicFindBy

  def html_list_to_array(dom_id)
    find_by(id: dom_id).all("li").map { |cell| cell.text.strip }
  end
end

World(HTMLHelpers)
