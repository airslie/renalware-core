module World
  module Pathology
    module GlobalAlgorithm
      module Domain
        # @section commands
        #
        def generate_pathology_request_form(form_parameters);
          family_name = form_parameters.fetch("patient")
          patient = Renalware::Patient.find_by!(family_name: family_name)
          patient = Renalware::Pathology.cast_patient(patient)

          clinic_name = form_parameters.fetch("clinic")
          @clinic = Renalware::Clinics::Clinic.find_by!(name: clinic_name)

          given_name, family_name = form_parameters.fetch("doctor").split(" ")
          @doctor = Renalware::Doctor.find_by!(given_name: given_name, family_name: family_name)

          @doctors = Renalware::Doctor.ordered
          @clinics = Renalware::Clinics::Clinic.ordered

          form_params = Renalware::Pathology::Forms::ParamsPresenter.new({clinic_id: @clinic.id, doctor_id: @doctor.id}, @doctors, @clinics)
          @patient = Renalware::Pathology::Forms::PatientPresenter.new(patient, form_params.clinic)
        end

        # @section expectations
        #
        def expect_patient_summary_to_match_table(patient_id, expected_table); end
        def expect_patient_specific_test(test_description); end
        def expect_no_request_descriptions_required
          expect(@patient).not_to have_patient_requests
        end

        def expect_request_description_required(request_description_code)
          expected_request_description =
            Renalware::Pathology::RequestDescription.find_by(code: request_description_code)
          @patient.global_requests_by_lab.each do |lab_name, request_descriptions|
            expect(expected_request_description).to eq(expected_request_description)
          end
        end
      end

      module Web
        include Domain
        # @section commands
        #

        def generate_pathology_request_form(form_parameters)
          clinic_name = form_parameters.fetch("clinic")
          clinic = Renalware::Clinics::Clinic.find_by!(name: clinic_name)

          given_name, family_name = form_parameters.fetch("doctor").split(" ")
          doctor = Renalware::Doctor.find_by!(given_name: given_name, family_name: family_name)

          telephone_number = form_parameters["telephone_number"]

          family_name = form_parameters.fetch("patient")
          patient = Renalware::Patient.find_by!(family_name: family_name)

          login_as @clyde
          visit pathology_forms_path({clinic_id: clinic, doctor_id: doctor, telephone: telephone_number, patient_ids: [patient.id]})
        end

        # @section expectations
        #
        def expect_patient_summary_to_match_table(patient_id, expected_table)
          table_from_html =
            find_by_id("patient_#{patient_id}_summary")
              .all("tr")
              .map do |row|
                row.all("th, td").map { |cell| cell.text.strip }
              end

          expected_table = expected_table.raw.map do |row|
            row.map do |cell|
              if cell == "TODAYS_DATE"
                I18n.l Date.current
              else
                cell
              end
            end
          end

          expect(table_from_html).to eq(expected_table)
        end

        def expect_patient_specific_test(test_description)
          expect(page).to have_content(test_description)
        end

        def expect_no_request_descriptions_required
          expect(page).to have_content("No tests required.")
        end

        def expect_request_description_required(request_description_code)
          request_description =
            Renalware::Pathology::RequestDescription.find_by(code: request_description_code)
          expect(page.text.downcase).to include(request_description.name.downcase)
        end
      end
    end
  end
end
