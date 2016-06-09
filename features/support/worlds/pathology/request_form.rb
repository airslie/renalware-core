module World
  module Pathology
    module GlobalAlgorithm
      module Domain
        # @section commands
        #
        def generate_pathology_request_forms(_clinician, form_parameters)
          family_name = form_parameters.fetch("patient")
          patient = Renalware::Patient.find_by!(family_name: family_name)
          patient = Renalware::Pathology.cast_patient(patient)

          clinic_name = form_parameters.fetch("clinic")
          clinic = Renalware::Clinics::Clinic.find_by!(name: clinic_name)

          given_name, family_name = form_parameters.fetch("doctor").split(" ")
          doctor = Renalware::Doctor.find_by!(given_name: given_name, family_name: family_name)

          Renalware::Pathology::RequestFormPresenter.wrap(
            [patient], clinic, doctor, form_parameters.slice(:telephone)
          )
        end

        # @section expectations
        #
        def expect_patient_summary_to_match_table(request_forms, patient, expected_table)
          request_form = find_request_form_for_patient(request_forms, patient)

          expected_table.rows_hash.each do |key, expected_value|
            expect(request_form.send(key.to_sym)).to eq(expected_value)
          end
        end

        def expect_patient_specific_test(request_forms, patient, expected_test_description)
          request_form = find_request_form_for_patient(request_forms, patient)

          request_form.patient_requests_by_lab.each do |_lab_name, patient_rules|
            patient_rules.each do |patient_rule|
              expect(patient_rule.test_description).to eq(expected_test_description)
            end
          end
        end

        def expect_no_request_descriptions_required(request_forms, patient)
          request_form = find_request_form_for_patient(request_forms, patient)

          expect(request_form).not_to have_patient_requests
        end

        def expect_request_description_required(request_forms, patient, request_description_code)
          request_form = find_request_form_for_patient(request_forms, patient)

          expected_request_description =
            Renalware::Pathology::RequestDescription.find_by(code: request_description_code)

          request_form.global_requests_by_lab.each do |_lab_name, request_descriptions|
            request_descriptions.each do |request_description|
              expect(request_description).to eq(expected_request_description)
            end
          end
        end

        private

        def find_request_form_for_patient(request_forms, patient)
          request_forms.find do |request_form|
            request_form.patient.id == patient.id
          end
        end
      end

      module Web
        include Domain
        # @section commands
        #

        def generate_pathology_request_forms(clinician, form_parameters)
          clinic_name = form_parameters.fetch("clinic")
          clinic = Renalware::Clinics::Clinic.find_by!(name: clinic_name)

          given_name, family_name = form_parameters.fetch("doctor").split(" ")
          doctor = Renalware::Doctor.find_by!(given_name: given_name, family_name: family_name)

          telephone = form_parameters["telephone"]

          family_name = form_parameters.fetch("patient")
          patient = Renalware::Patient.find_by!(family_name: family_name)

          login_as clinician
          visit pathology_forms_path({
            clinic_id: clinic,
            doctor_id: doctor,
            telephone: telephone,
            patient_ids: [patient.id]
          })
        end

        # @section expectations
        #
        # TODO: Make these methods work when the page has multiple request forms
        def expect_patient_summary_to_match_table(_request_forms, _patient, expected_table)
          expected_table.rows_hash.each do |key, expected_value|
            value_in_web = find("td[data-role=#{key}]").text
            expect(value_in_web).to eq(expected_value)
          end
        end

        def expect_patient_specific_test(_request_forms, _patient, test_description)
          expect(page).to have_content(test_description)
        end

        def expect_no_request_descriptions_required(_request_forms, _patient)
          expect(page).to have_content("No tests required.")
        end

        def expect_request_description_required(_request_forms, _patient, request_description_code)
          request_description =
            Renalware::Pathology::RequestDescription.find_by(code: request_description_code)
          expect(page.text.downcase).to include(request_description.name.downcase)
        end
      end
    end
  end
end
