module Renalware

  patient = HD.cast_patient(Patient.find_by(local_patient_id: "Z100003"))

  log "Assign HD modality to Francois RABBIT" do
    description = HD::ModalityDescription.first!
    patient.set_modality(description: description,
     started_on: 1.week.ago, created_by_id: Renalware::User.first.id)
  end

  log "Assign some HD preferences to Francois RABBIT" do

    preference_set = HD::PreferenceSet.find_or_initialize_by(patient: patient)
    preference_set.attributes = {
      schedule: "mon_wed_fri_am",
      entered_on: 1.week.ago.to_date,
      by: User.first
    }
    preference_set.save!
  end

  profile = nil
  log "Assign an HD profile to Francois RABBIT" do
    profile = HD::Profile.find_or_initialize_by(patient: patient)
    profile.attributes = {
      by: User.first,
      hospital_unit: Hospitals::Unit.hd_sites.first,
      schedule: "mon_wed_fri_am",
      prescribed_time: 180,
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
  end

  dry_weight = nil

  log "Create dry weight to Francois RABBIT" do
    dry_weight = HD::DryWeight.find_or_create_by(
      patient: patient,
      weight: 140.5,
      assessed_on: Time.zone.now,
      assessor_id: Renalware::User.first.id,
      created_by_id: Renalware::User.first.id
    )
  end

  log "Assign HD sessions to Francois RABBIT" do

    units = Hospitals::Unit.hd_sites.limit(3).to_a
    users = User.limit(3).to_a
    start_times = ["13:00", "13:15", "13:30"]
    end_times = ["15:30", "15:45", "16:00"]

    def self.session_document
      {
        info: {
          hd_type: "hd",
          machine_no: rand(100..222),
          access_confirmed: true,
          access_side: "right",
          access_site: "Brachio-basilic & transposition",
          access_type: "Arteriovenous graft (AVG)",
          access_type_abbreviation: "AVG",
          single_needle: "no",
          lines_reversed: "no",
          fistula_plus_line: "no",
          dialysis_fluid_used: "a10",
          is_access_first_use: "no"
        },
        dialysis: {
          flow_rate: rand(100..200),
          blood_flow: rand(100..200),
          machine_ktv: rand(0.5..3.0).round(1),
          machine_urr: rand(0.6..10.0).round(1),
          fluid_removed: rand(1.0..10.0).round(1),
          venous_pressure: rand(100..200),
          litres_processed: rand(10.0..20.0).round(1),
          arterial_pressure: rand(5..10)
        },
        observations_after: {
          pulse: rand(60..80),
          weight: rand(110.0..112.0).round(1),
          bm_stix: rand(0.6..10.0).round(1),
          temperature: rand(36..38),
          blood_pressure: {
            systolic: rand(100..120),
            diastolic: rand(80..99)
          }
        },
        observations_before: {
          pulse: rand(60..80),
          weight: rand(106.0..110.0).round(1),
          bm_stix: rand(0.6..10.0).round(1),
          temperature: rand(36..38),
          blood_pressure: {
            systolic: rand(100..120),
            diastolic: rand(80..99)
          }
        }
      }
    end

    # Make the most recent session ongoing
    HD::Session::Open.create!(
      patient: patient,
      hospital_unit: units.sample,
      performed_on: Time.zone.today,
      start_time: "09:00",
      signed_on_by: users.sample,
      by: users.sample
    )

    # Create some closed and dna sessions on random dates over the past 6 years
    50.times do |i|
      date = rand(6.months).seconds.ago

      # She misses every 5th session
      if i % 5 == 0
        HD::Session::DNA.create!(
          patient: patient,
          hospital_unit: units.sample,
          performed_on: date,
          start_time: start_times.sample,
          signed_on_by: users.sample,
          by: users.sample,
          notes: "",
          document: {
            patient_on_holiday: "yes"
          }
        )
      else
        # TODO: call SaveSession here?
        HD::Session::Closed.create!(
          patient: HD.cast_patient(patient),
          hospital_unit: units.sample,
          performed_on: date,
          start_time: start_times.sample,
          end_time: end_times.sample,
          signed_on_by: users.sample,
          signed_off_at: date,
          signed_off_by: users.sample,
          by: users.sample,
          document: session_document,
          dry_weight_id: dry_weight.id,
          profile_id: profile.id
        )
      end
    end
  end

  log "Generate HD statistics for the last 6 months of HD Sessions" do
    # Generate HD statistics for the last 6 months of HD Sessions, starting with last month - we
    # don't do monthly stats for the current month
    (1..6).each do |month|
      date = Date.today - month.months
      period = MonthPeriod.new(month: date.month, year: date.year)
      HD::GenerateMonthlyStatisticsForPatient.new(patient: patient,
                                                  period: period).call
    end

    # Update the rolling HD statistics
    HD::UpdateRollingPatientStatistics.new(patient: patient).call
  end
end
