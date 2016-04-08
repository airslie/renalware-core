module World
  module Clinics
    module ClinicVisits
      module Domain
        # @section commands
        #

        def record_clinic_visit
          fill_in "Date", with: "20-07-2015 10:45"
          select "Access", from: "Clinic"
          fill_in "Height", with: "1.78"
          fill_in "Weight", with: "82.5"
          fill_in "Blood Pressure", with: "110/75"

          click_on "Save"
        end

        # @section expectations
        #
        def expect_clinic_visit_to_exist(patient)
          patient = Renalware::Clinics.cast_patient(patient)
          expect(patient.clinic_visits.length).to eq(1)
        end
      end
    end
  end
end