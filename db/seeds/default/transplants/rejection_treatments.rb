# frozen_string_literal: true

require_relative "../../seeds_helper"

module Renalware
  extend SeedsHelper

  log "Adding Transplant Rejection Treatments" do
    names = [
      "None",
      "Methylprednisolone",
      "ATG",
      "Methylprednisolone and ATG",
      "PEX and ivImmunoglobulin",
      "Change in oral immunosuppression"
    ]

    names.each_with_index do |name, index|
      Transplants::RejectionTreatment.find_or_create_by(
        name: name,
        position: index
      )
    end
  end
end
