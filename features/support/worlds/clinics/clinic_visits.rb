module World
  module Clinics
    module ClinicVisits
      module Domain
        # @section commands
        #
        def create_clinic_visit(patient, user)
          clinic = Renalware::Clinics::Clinic.find_by(name: 'Access')
          patient = Renalware::Clinics.cast_patient(patient)
          Renalware::Clinics::ClinicVisit.create(
            patient: patient,
            clinic: clinic,
            date: Time.now,
            height: 1.7,
            weight: 71,
            systolic_bp: 112,
            diastolic_bp: 71,
            created_by: user,
            updated_by: user
          )
        end

        def record_clinic_visit(patient, user)
          create_clinic_visit(patient, user)
        end

        def update_clinic_visit(clinic_visit, _patient, user)
          clinic = Renalware::Clinics::Clinic.find_by(name: 'AKI')
          clinic_visit.update_attributes(
            clinic: clinic,
            height: 1.71,
            weight: 75.0,
            by: user
          )
        end

        # @section expectations
        #
        def expect_clinic_visit_to_exist(patient)
          patient = Renalware::Clinics.cast_patient(patient)
          expect(patient.clinic_visits.length).to eq(1)
        end

        def expect_clinic_visit_to_be_updated(clinic_visit)
          clinic_visit = Renalware::Clinics::ClinicVisit.find(clinic_visit.id)
          expect(clinic_visit.clinic_id).to eq(2)
          expect(clinic_visit.height).to eq(1.71)
          expect(clinic_visit.weight).to eq(75)
        end
      end

      module Web
        include Domain

        def record_clinic_visit(patient, _user)
          visit new_patient_clinic_visit_path(patient_id: patient.id)

          fill_in "Date", with: "20-07-2015 10:45"
          select "Access", from: "Clinic"
          fill_in "Height", with: "1.78"
          fill_in "Weight", with: "82.5"
          fill_in "Blood Pressure", with: "110/75"

          click_on "Save"
        end

        def update_clinic_visit(clinic_visit, patient, _user)
          visit edit_patient_clinic_visit_path(
            patient_id: patient.id,
            id: clinic_visit.id
          )
          select "AKI", from: "Clinic"
          fill_in "Height", with: "1.71"
          fill_in "Weight", with: "75"
          fill_in "Blood Pressure", with: "128/95"

          click_on "Update"
        end
      end
    end
  end
end
