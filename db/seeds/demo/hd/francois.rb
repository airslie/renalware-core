module Renalware
  log "Assign Unit HD modality to Francois RABBIT"

  patient = Patient.find_by(local_patient_id: "Z100003")
  description = HD::ModalityDescription.first!
  patient.set_modality(description: description, started_on: 1.week.ago)

  log "Assign some HD preferences to Francois RABBIT"

  preference_set = HD::PreferenceSet.find_or_initialize_by(patient: HD.cast_patient(patient))
  preference_set.attributes = {
    schedule: "mon_wed_fri_am",
    entered_on: 1.week.ago.to_date,
    by: User.first
  }
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
        level: :level1,
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
      by: users.sample,
      document: {
        hdf: {
          subs_goal: 1.0,
          subs_rate: 1.0,
          subs_volume: 1.0,
          subs_fluid_pct: 1
        },
        info: {
          hd_type: "hd",
          machine_no: "123",
          access_side: "left",
          access_site: "Axillary vein line",
          access_type: "Arteriovenous fistula (AVF)",
          single_needle: "no",
          lines_reversed: "no",
          fistula_plus_line: "no",
          dialysis_fluid_used: "a7",
          is_access_first_use: "no"
        },
        dialysis: {
          flow_rate: 200,
          blood_flow: 100,
          machine_ktv: 1.0,
          machine_urr: 1,
          fluid_removed: 10.0,
          venous_pressure: 100,
          litres_processed: 10.0,
          arterial_pressure: 100
        },
        complications: {
          access_site_status: "clean_and_dry"
        },
        observations_after: {
          pulse: 72,
          weight: 120.0,
          bm_stix: 1.0,
          temperature: 37.0,
          blood_pressure: {
            systolic: 121,
            diastolic: 81
          }
        },
        observations_before: {
          pulse: 67,
          weight: 120.1,
          bm_stix: 1.1,
          temperature: 36.0,
          blood_pressure: {
            systolic: 120,
            diastolic: 80
          }
        }
      }
    )
    if i == 0
      session.end_time = nil
      session.signed_off_by = nil
    end
    session.save!
  end
end
