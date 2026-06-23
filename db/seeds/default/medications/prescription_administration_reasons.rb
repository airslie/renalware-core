require_relative "../../seeds_helper"

module Renalware
  Rails.benchmark "Adding outpatient prescription administration reasons" do
    [
      "No supply available",
      "Patient refused",
      "Patient unwell",
      "Wrong dose / route"
    ].each do |reason|
      Medications::OutpatientPrescriptionAdministrationReason.find_or_create_by!(name: reason)
    end
  end
end
