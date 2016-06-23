module World
  module Clinics
    module Appointments
      module Domain
        # @section commands
        #
        def create_appointment(table_row)
          starts_at = parse_date_time_for_appointment(
            table_row["starts_at_date"],
            table_row["starts_at_time"]
          )
          user = find_or_create_user_for_appointment(table_row["user"])
          clinic = find_or_create_clinic_for_appointment(table_row["clinic"])
          patient = find_or_create_patient_by_name(table_row["patient"])

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

        private

        def parse_date_time_for_appointment(date_str, time_str)
          date = Time.strptime(date_str, "%d-%m-%Y").in_time_zone
          time_arr = time_str.split(":")

          date.change(hour: time_arr[0], min: time_arr[1])
        end

        def find_or_create_clinic_for_appointment(clinic_name)
          Renalware::Clinics::Clinic.find_or_create_by!(name: clinic_name)
        end

        def find_or_create_user_for_appointment(user_full_name)
          given_name, family_name = user_full_name.split(" ")

          Renalware::User.find_or_create_by!(
            given_name: given_name,
            family_name: family_name
          ) do |user|
            user.email = "#{given_name}.#{family_name}@renalware.net"
            user.username = "#{given_name}_#{family_name}"
            user.approved = true
            user.password = "supersecret"
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
            expect(appointment[1]).to eq(expected_appointment["date"])
            expect(appointment[2]).to eq(expected_appointment["starts_at"])
            expect(appointment[3]).to eq(expected_appointment["patient"])
            expect(appointment[4]).to eq(expected_appointment["clinic"])
            expect(appointment[5]).to eq(expected_appointment["user"])
          end
        end
      end
    end
  end
end
