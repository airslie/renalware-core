module World
  module Clinics
    module ClinicVisits
      module Domain
        # @section commands
        #
        def create_appointment(table_row)
          starts_at = Time.strptime(table_row["starts_at_date"], "%d-%m-%Y").in_time_zone
          starts_at_time = table_row["starts_at_time"].split(":")
          starts_at = starts_at.change(hour: starts_at_time[0], min: starts_at_time[1])

          patient_given_name, patient_family_name = table_row["patient"].split(" ")
          user_given_name, user_family_name = table_row["user"].split(" ")

          patient = Renalware::Clinics::Patient.find_by!(
            given_name: patient_given_name, family_name: patient_family_name
          )
          user = Renalware::User.find_by!(given_name: user_given_name,family_name: user_family_name)
          clinic = Renalware::Clinics::Clinic.find_by!(name: table_row["clinic"])

          Renalware::Clinics::Appointment.create!(
            starts_at: starts_at,
            patient: patient,
            user: user,
            clinic: clinic
          )
        end

        def view_appointments(_clinician, params = {})
          query_params = params.fetch(:q, {})

          Renalware::Clinics::AppointmentQuery.new(query_params).call
        end

        # @section expectations
        #
        def expect_appointments_to_match(appointments, expected_appointments)
          appointments.zip(expected_appointments).each do |appointment, expected_appointment|
            expect(appointment.start_time).to eq(expected_appointment["starts_at"])
            expect(appointment.patient.full_name).to eq(expected_appointment["patient"])
            expect(appointment.user.full_name).to eq(expected_appointment["user"])
            expect(appointment.clinic.name).to eq(expected_appointment["clinic"])
          end
        end
      end

      module Web
        include Domain

        # @section commands
        #
        def view_appointments(clinician, params = {})
          login_as clinician

          visit appointments_path(params)

          html_table_to_array("appointments")
        end

        # @section expectations
        #
        def expect_appointments_to_match(appointments, expected_appointments)
          appointments.shift # Remove column headers row

          appointments.zip(expected_appointments).each do |appointment, expected_appointment|
            expect(appointment[0]).to eq(expected_appointment["date"])
            expect(appointment[1]).to eq(expected_appointment["starts_at"])
            expect(appointment[2]).to eq(expected_appointment["patient"])
            expect(appointment[3]).to eq(expected_appointment["clinic"])
            expect(appointment[4]).to eq(expected_appointment["user"])
          end
        end
      end
    end
  end
end
