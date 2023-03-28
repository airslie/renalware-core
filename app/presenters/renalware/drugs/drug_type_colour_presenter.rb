# frozen_string_literal: true

module Renalware
  module Drugs
    class DrugTypeColourPresenter
      def style(drug_types)
        eligible_colors = drug_types.sort_by(&:weighting).reverse.filter_map(&:colour)
        return if eligible_colors.empty?

        "background-color: #{eligible_colors.first}"
      end
    end
  end
end
