module World
  module Global
    def find_link_in_row_with(text:, link_label:)
      find(:xpath, "//tr[td[contains(.,'#{text}')]]/td/a", text: link_label)
    end
  end
end