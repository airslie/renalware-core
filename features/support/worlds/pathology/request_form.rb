module World
  module Pathology
    module GlobalAlgorithm
      module Domain
        # @section commands
        #
        def extract_request_form_params(form_parameters)
          clinic_name = form_parameters.fetch("clinic")
          clinic = Renalware::Clinics::Clinic.find_by!(name: clinic_name)

          given_name, family_name = form_parameters.fetch("doctor").split(" ")
          doctor = Renalware::Doctor.find_by!(given_name: given_name, family_name: family_name)

          telephone = form_parameters["telephone"]

          patient_names = form_parameters.fetch("patients").split(", ")
          patients = patient_names.map do |family_name|
            Renalware::Pathology::Patient.find_by!(family_name: family_name)
          end

          [patients, clinic, doctor, telephone]
        end

        def generate_pathology_request_forms(_clinician, form_parameters)
          patients, clinic, doctor, telephone = extract_request_form_params(form_parameters)

          Renalware::Pathology::RequestFormPresenter.wrap(
            patients, clinic, doctor, telephone: telephone
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

        def expect_request_description_required(request_forms, patient, expected_request_description_code)
          patient_request_descriptions, expected_request_description =
            parse_request_description_params(request_forms, patient, expected_request_description_code)

          expect(patient_request_descriptions).to include(expected_request_description)
        end

        def expect_request_description_not_required(request_forms, patient, expected_request_description_code)
          patient_request_descriptions, expected_request_description =
            parse_request_description_params(request_forms, patient, expected_request_description_code)

          expect(patient_request_descriptions).not_to include(expected_request_description)
        end


        private

        def parse_request_description_params(request_forms, patient, expected_request_description_code)
          request_form = find_request_form_for_patient(request_forms, patient)
          patient_request_descriptions = request_form.global_requests_by_lab.values.flatten

          expected_request_description =
            Renalware::Pathology::RequestDescription.find_by!(code: expected_request_description_code)

          [patient_request_descriptions, expected_request_description]
        end

        def find_request_form_for_patient(request_forms, patient)
          request_forms.detect do |request_form|
            request_form.patient.id == patient.id
          end
        end
      end

      module Web
        include Domain
        # @section commands
        #
        def generate_pathology_request_forms(clinician, form_parameters)
          patients, clinic, doctor, telephone = extract_request_form_params(form_parameters)

          login_as clinician
          visit pathology_forms_path({
            clinic_id: clinic,
            doctor_id: doctor,
            telephone: telephone,
            patient_ids: patients
          })
        end

        # @section expectations
        #
        # TODO: Make these methods work when the page has multiple request forms
        def expect_patient_summary_to_match_table(_request_forms, patient, expected_table)
          expected_table.rows_hash.each do |key, expected_value|
            value_in_web = find("//div[data-patient-id='#{patient.id}'][data-role='form_summary']//td[data-role='#{key}']").text
            expect(value_in_web).to eq(expected_value)
          end
        end

        def expect_patient_specific_test(_request_forms, patient, test_description)
          request_form = find_request_form_for_patient(_request_forms, patient)

          expect(request_form).to include(test_description)
        end

        def expect_request_description_not_required(_request_forms, patient, expected_request_description_code)
          request_form = find_request_form_for_patient(_request_forms, patient)

          expect(request_form).to include("No tests required.")

        end

        def expect_request_description_required(_request_forms, patient, request_description_code)
          request_form = find_request_form_for_patient(_request_forms, patient)
          request_description =
            Renalware::Pathology::RequestDescription.find_by(code: request_description_code)

          expect(request_form.downcase).to include(request_description.name.downcase)
        end

        private

        def find_request_form_for_patient(_request_forms, patient)
          find("div[data-patient-id='#{patient.id}'][data-role='form_pathology']").text
        end
      end
    end
  end
end
