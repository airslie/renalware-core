module World
  module Patients
    module PrimaryCarePhysician

      module Domain
        def assign_primary_care_physician_to(patient, primary_care_physician:, user:)
          patient.primary_care_physician = primary_care_physician
          patient.save!
        end

        def expect_patient_primary_care_physician_to_be(primary_care_physician, patient:)
          expect(patient.primary_care_physician).to eq(primary_care_physician)
        end
      end

      module Web
        def assign_primary_care_physician_to(patient, primary_care_physician:, user:)
          login_as user
          visit patient_path(patient)

          click_on "Change GP"
        end

        def expect_patient_primary_care_physician_to_be(primary_care_physician, patient:)
        end
      end
    end
  end
end
