module World
  module Global
    def find_link_in_row_with(text:, link_label:)
      find(:xpath, "//tr[td[contains(.,'#{text}')]]/td/a", text: link_label)
    end

    def transplant_hospital
      Renalware::Hospitals::Centre.find_by(is_transplant_site: true)
    end

    def hd_unit
      Renalware::Hospitals::Unit.hd_sites.first
    end
  end
end