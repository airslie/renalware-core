# frozen_string_literal: true

require_relative "../../seeds_helper"

module Renalware
  extend SeedsHelper

  log "Adding HD Prescription Administration Reasons" do
    [
      "No supply available",
      "Target HB exceeded",
      "Patient refused",
      "Patient unwell",
      "Patient received blood transfusion",
      "Wrong dose / route"
    ].each do |reason|
      HD::PrescriptionAdministrationReason.find_or_create_by!(name: reason)
    end
  end
end
