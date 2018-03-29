# frozen_string_literal: true

module Renalware
  log "Creating Admission::Requests" do
    patient_ids = Patient.order("RANDOM()").limit(30).pluck(:id).uniq
    hospital_unit_ids = Hospitals::Unit.pluck(:id)
    reason_ids = Renalware::Admissions::RequestReason.pluck(:id)
    users = User.limit(10).select(:id)

    requests = patient_ids.map do |patient_id|
      Admissions::Request.new(
        patient_id: patient_id,
        hospital_unit_id: hospital_unit_ids.sample,
        reason_id: reason_ids.sample,
        notes: "Some notes",
        priority: Renalware::Admissions::Request.priority.values.sample,
        position: 1,
        updated_by: users.sample,
        created_by: users.sample
      )
    end

    Admissions::Request.import! requests
  end
end
