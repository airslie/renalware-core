# frozen_string_literal: true

module Renalware
  log "Creating Admissions::Admission (inpatients)" do
    patients = Renalware::Patient
      .order("RANDOM()")
      .select(:id)
      .joins(:current_modality)
      .includes(:current_modality)
      .limit(20)
    hospital_ward_ids = Hospitals::Ward.pluck(:id)
    users = User.limit(10).select(:id)

    admissions = patients.map do |patient|
      admitted_on = (rand * 100).days.ago
      Admissions::Admission.new(
        patient: patient,
        hospital_ward_id: hospital_ward_ids.sample,
        admitted_on: admitted_on,
        admission_type: Admissions::Admission.admission_type.values.sample,
        modality_at_admission: patient.current_modality,
        reason_for_admission: "Lorem ipsum dolor sit amet.",
        updated_by: users.sample,
        created_by: users.sample
      )
    end

    (admissions.count / 2).times do
      admission = admissions.sample
      admission.discharge_summary = "Discharge summary"
      admission.summarised_on = admission.admitted_on + 2.days
      admission.discharged_on = admission.admitted_on + 2.days
      admission.discharge_destination = Admissions::Admission.discharge_destination.values.sample
      admission.summarised_by = users.sample
      admission.destination_notes = <<-NOTES
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
        incididunt ut labore et dolore magna aliqua.
      NOTES
    end

    Admissions::Admission.import! admissions
  end
end
