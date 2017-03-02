module Renalware

  # add random patients plus RABBITs
  users = User.all.to_a

  log "Adding Patients to Worryboard" do
    Patient.transaction do
      patients = Patient.all
      i = 0
      patients.each do |patient|
        i += 1
        if i % 10 == 0 or patient.family_name == "RABBIT"
          Renalware::Patients::Worry.new(
            patient: patient,
            by: users.sample).save!
        end
      end
    end
  end
end
