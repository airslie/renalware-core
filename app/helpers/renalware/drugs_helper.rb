module Renalware
  module DrugsHelper

    def drug_select_options
      options_for_select Drugs::Type.all.reject{ |r| r.name == "Peritonitis" }.map { |dt| [dt.name, dt.name.downcase] }
    end

    def drug_types_colour_tag(drug_type)
      if drug_type.map(&:name).include?("ESA")
        return "esa"
      elsif drug_type.map(&:name).include?("Immunosuppressant")
        return "immunosuppressant"
      else
        return "drug"
      end
    end

    def drug_types_tag(drug_type)
      if drug_type.map(&:name).include?("ESA")
        return "ESA"
      elsif drug_type.map(&:name).include?("Immunosuppressant")
        return "Immunosuppressant"
      else
        return "Standard"
      end
    end

  end
end
