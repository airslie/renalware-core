module Renalware
  log "Assign Unit HD modality to Francois RABBIT"
  patient = Patient.find_by(local_patient_id: "Z100003")
  description = HD::ModalityDescription.first!
  patient.set_modality(description: description, started_on: 1.week.ago)

  log "Assign some HD preferences to Francois RABBIT"
  preference_set = HD::PreferenceSet.find_or_initialize_by(patient: HD.cast_patient(patient))
  preference_set.attributes = { schedule: "mon_wed_fri_am", entered_on: 1.week.ago.to_date, by: User.first }
  preference_set.save!

  log "Assign an HD profile to Francois RABBIT"
  profile = HD::Profile.find_or_initialize_by(patient: HD.cast_patient(patient))
  profile.attributes = {
    by: User.first,
    hospital_unit: Hospitals::Unit.hd_sites.first,
    schedule: "mon_wed_fri_am",
    prescribed_time: 150,
    prescribed_on: 1.week.ago.to_date,
    prescriber: User.first,
    named_nurse: User.last,
    transport_decider: User.first,
    document: {
      dialysis: {
        hd_type: :hd,
        cannulation_type: "Buttonhole",
        needle_size: "44",
        single_needle: :yes,
        dialysate: :a7,
        flow_rate: 300,
        blood_flow: 400,
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
        stop_time: "0:45",
      },
      drugs: {
        on_esa: :no,
        on_iron: :no,
        on_warfarin: :no
      },
      transport: {
        has_transport: :yes,
        type: :taxi,
        decided_on: 2.days.ago.to_date,
      },
      care_level: {
        required: :no,
        assessed_on: 3.days.ago.to_date
      }
    }
  }
  profile.save!

  log "Assign HD sessions to Francois RABBIT"
  units = Hospitals::Unit.hd_sites.limit(3).to_a
  users = User.limit(3).to_a
  start_times = ["13:00", "13:15", "13:30"]
  end_times = ["15:30", "15:45", "16:00"]
  20.times do |i|
    session = HD::Session.new(
      patient: HD.cast_patient(patient),
      hospital_unit: units.sample,
      performed_on: (i*2).days.ago,
      start_time: start_times.sample,
      end_time: end_times.sample,
      signed_on_by: users.sample,
      signed_off_by: users.sample,
      by: users.sample
    )
    if i == 0
      session.end_time = nil
      session.signed_off_by = nil
    end
    session.save!
  end
end
