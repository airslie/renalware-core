# frozen_string_literal: true

# rubocop:disable Metrics/AbcSize, Metrics/MethodLength
module World
  module Clinics
    module Appointments
      module Domain
        # @section commands

        def create_appointment(table_row)
          starts_at = parse_date_time_for_appointment(
            table_row["starts_at_date"],
            table_row["starts_at_time"]
          )
          consultant = find_or_create_consultant_for_appointment(table_row["consultant"])
          clinic = find_or_create_clinic_for_appointment(table_row["clinic"])
          patient = find_or_create_patient_by_name(table_row["patient"])

          Renalware::Clinics::Appointment.create!(
            starts_at: starts_at,
            patient: patient,
            consultant: consultant,
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
            expect(appointment.patient.to_s).to eq(expected_appointment["patient"])
            expect(appointment.consultant.name).to eq(expected_appointment["consultant"])
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

        def find_or_create_consultant_for_appointment(name)
          FactoryBot.create(:consultant, name: name)
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
            expect(appointment[2]).to eq(l(DateTime.parse(expected_appointment["date"])))
            # expect(appointment[3]).to eq(expected_appointment["starts_at"])
            expect(appointment[3]).to eq(expected_appointment["patient"])
            expect(appointment[7]).to eq(expected_appointment["clinic"])
            expect(appointment[8]).to eq(expected_appointment["consultant"])
          end
        end
      end
    end
  end
end
# rubocop:enable Metrics/AbcSize, Metrics/MethodLength
