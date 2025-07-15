module World
  module Clinics
    module ClinicVisits
      module Domain
        def create_clinic_visit(patient, user)
          clinic = Renalware::Clinics::Clinic.find_by(name: "Access")
          patient = Renalware::Clinics.cast_patient(patient)
          Renalware::Clinics::ClinicVisit.create(
            patient: patient,
            clinic: clinic,
            date: Time.zone.now,
            height: 1.7,
            weight: 71,
            systolic_bp: 112,
            diastolic_bp: 71,
            standing_systolic_bp: 108,
            standing_diastolic_bp: 67,
            pulse: 100,
            temperature: 37.3,
            did_not_attend: false,
            notes: "Notes",
            admin_notes: "Admin notes",
            created_by: user,
            updated_by: user
          )
        end

        def clinic_visit_for(patient)
          patient = clinics_patient(patient)
          patient.clinic_visits.first!
        end
      end

      module Web
        include Domain
      end
    end
  end
end
