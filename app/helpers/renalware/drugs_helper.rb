# frozen_string_literal: true

module Renalware
  module DrugsHelper
    def drug_select_options
      options_for_select(
        Drugs::Type
          .all
          .reject { |dt| dt.name == "Peritonitis" }
          .map { |dt| [dt.name, dt.name.downcase] }
      )
    end

    # Now that we have a drug_types.colour column e.g. '#aaa' we can use here.
    # Where the drug belongs to 2 drug types, we need to be sure to choose the colour of the most
    # clinically significant drug type - eg 'ESA' wins over 'My other drug type'.
    # This should be done by ordering a drugs types and taking the one with the highest value
    # in the #weighting column - i.e. ESA will have a a large value in this column to ensure it
    # trumps other types and its colour is used.
    def drug_types_colour_tag(drug_types)
      drug_names = drug_types.map(&:name)
      return "esa" if drug_names.include?("ESA")
      return "immunosuppressant" if drug_names.include?("Immunosuppressant")

      "other"
    end

    def drug_types_tag(drug_type)
      if drug_type.map(&:name).include?("ESA")
        "ESA"
      elsif drug_type.map(&:name).include?("Immunosuppressant")
        "Immunosuppressant"
      else
        "Standard"
      end
    end
  end
end
