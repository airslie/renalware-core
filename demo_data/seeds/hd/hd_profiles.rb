# frozen_string_literal: true

module Renalware
  log "Assigning HD Profiles to Random Patients" do
    kch_doc = User.find_by!(username: "kchdoc")
    kch_nurse = User.find_by!(username: "kchnurse")
    kent_doc = User.find_by!(username: "kentdoc")
    modal_weeks = (30..50).to_a
    schedule_definitions = HD::ScheduleDefinition.all
    times = [180, 210, 240, 270]
    rates = [300, 400, 500]
    flows = [300, 400, 500]

    Patient.transaction do
      patients = Patient.all
      i = 0
      patients.each do |patient|
        i += 1
        next unless i % 10 == 0

        patient = HD.cast_patient(patient)
        # Assign HD modality
        hd_started_on = modal_weeks.sample.weeks.ago

        Modalities::ChangePatientModality
          .new(patient: patient, user: kent_doc)
          .call(
            description: HD::ModalityDescription.first!,
            started_on: hd_started_on
          )

        # Assign some HD preferences
        preference_set = HD::PreferenceSet.find_or_initialize_by(patient: patient)
        preference_set.attributes = {
          schedule_definition: schedule_definitions.sample,
          hospital_unit: Hospitals::Unit.hd_sites.sample,
          entered_on: hd_started_on,
          by: kent_doc
        }
        preference_set.save!

        profile = nil
        # Assign an HD profile -- NB could be further randomised
        profile = HD::Profile.find_or_initialize_by(patient: patient)
        profile.dialysate = HD::Dialysate.first
        profile.attributes = {
          by: kch_doc,
          hospital_unit: Hospitals::Unit.hd_sites.sample,
          schedule_definition: schedule_definitions.sample,
          prescribed_time: times.sample,
          prescribed_on: hd_started_on,
          prescriber: kch_doc,
          named_nurse: kch_nurse,
          transport_decider: User.last,
          document: {
            dialysis: {
              hd_type: :hd,
              cannulation_type: "Buttonhole",
              needle_size: "44",
              single_needle: :yes,
              flow_rate: rates.sample,
              blood_flow: flows.sample,
              dialyser: "FX CorDiax 120",
              potassium: 2,
              calcium: 1.5,
              temperature: 36.0,
              bicarbonate: 35,
              has_sodium_profiling: :no,
              sodium_first_half: 137,
              sodium_second_half: 145
            },
            anticoagulant: {
              type: :heparin,
              loading_dose: 45,
              hourly_dose: 66,
              stop_time: "0:45"
            },
            drugs: {
              on_esa: :no,
              on_iron: :no,
              on_warfarin: :no
            },
            transport: {
              has_transport: :yes,
              type: :taxi,
              decided_on: hd_started_on
            },
            care_level: {
              level: :level1,
              assessed_on: hd_started_on
            }
          }
        }
        profile.save!
      end
    end
  end
end
