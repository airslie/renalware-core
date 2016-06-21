module World
  module Pathology
    module GlobalAlgorithm
      module Domain
        # @section helpers
        #
        def extract_request_form_params(form_params)
          clinic_name = form_params[:clinic]
          clinic =
            if clinic_name.present?
              Renalware::Clinics::Clinic.find_by!(name: clinic_name)
            end

          user_names = form_params[:user]
          user =
            if user_names.present?
              given_name, family_name = user_names.split(" ")
              Renalware::User.find_by(given_name: given_name, family_name: family_name)
            end

          telephone = form_params[:telephone]

          patient_names = form_params.fetch(:patients).split(", ")
          patients = patient_names.map do |patient_family_name|
            Renalware::Pathology::Patient.find_by!(family_name: patient_family_name)
          end

          [patients, clinic, user, telephone]
        end

        # @section commands
        #
        def generate_request_forms_for_single_patient(_clinician, params)
          patients, clinic, user, telephone = extract_request_form_params(params)

          options = { patient_ids: patients.map(&:id) }
          options[:clinic_id] = clinic.id if clinic.present?
          options[:user_id] = user.id if user.present?
          options[:telephone] = telephone if telephone.present?

          request_form_options =
            Renalware::Pathology::RequestAlgorithm::RequestFormOptions.new(options)

          Renalware::Pathology::RequestFormPresenter.wrap(patients, request_form_options)
        end

        def generate_request_forms_for_appointments(_clinician, appointments)
          generate_request_forms_for_single_patient(
            _clinician,
            patients: appointments.map(&:patient)
          )
        end

        # @section expectations
        #
        def expect_patient_summary_to_match_table(request_forms, patient, expected_table)
          request_form = find_request_form_for_patient(request_forms, patient)

          expected_table.rows_hash.each do |key, expected_value|
            expected_value = nil if expected_value.blank?

            expect(request_form.send(key.to_sym).to_s).to eq(expected_value.to_s)
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

        def expect_request_description_required(request_forms, patient, expected_request_description_code)
          request_form = find_request_form_for_patient(request_forms, patient)
          patient_request_descriptions = request_form.global_requests_by_lab.values.flatten

          expected_request_description =
            Renalware::Pathology::RequestDescription.find_by!(code: expected_request_description_code)

          expect(patient_request_descriptions).to include(expected_request_description)
        end

        def expect_no_request_descriptions_required(request_forms, patient)
          request_form = find_request_form_for_patient(request_forms, patient)
          required_request_descriptions = request_form.global_requests_by_lab.values.flatten

          expect(required_request_descriptions.count).to eq(0)
        end

        def expect_pathology_form(request_forms, patient, expected_pathology)
          request_description = expected_pathology[:global_pathology]
          patient_test = expected_pathology[:patient_pathology]

          if expected_pathology[:global_pathology].present?
            expect_request_description_required(request_forms, patient, request_description)
          else
            expect_no_request_descriptions_required(request_forms, patient)
          end

          expect_patient_specific_test(request_forms, patient, patient_test)
        end

        private

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
        def generate_request_forms_for_single_patient(clinician, params)
          patients, clinic, user, telephone = extract_request_form_params(params)

          login_as clinician

          visit patient_pathology_required_observations_path(patient_id: patients.first.id)

          click_on "Generate Forms"

          update_request_form_clinic(clinic.name) if clinic.present?
          update_request_form_user(user.full_name) if user.present?
          update_request_form_telephone(telephone)  if telephone.present?
        end

        # @section expectations
        #
        def expect_patient_summary_to_match_table(_request_forms, patient, expected_table)
          expected_table.rows_hash.each do |key, expected_value|
            xpath =
              "//div[data-patient-id='#{patient.id}'][data-role='form_summary']//td[data-role='#{key}']"
            value_in_web = find(xpath).text
            expect(value_in_web).to eq(expected_value)
          end
        end

        def expect_patient_specific_test(request_forms, patient, test_description)
          request_form = find_request_form_for_patient(request_forms, patient)

          expect(request_form).to include(test_description)
        end

        def expect_no_request_descriptions_required(request_forms, patient)
          request_form = find_request_form_for_patient(request_forms, patient)

          expect(request_form).to include("No tests required.")

        end

        def expect_request_description_required(request_forms, patient, request_description_code)
          request_form = find_request_form_for_patient(request_forms, patient)
          request_description =
            Renalware::Pathology::RequestDescription.find_by(code: request_description_code)

          expect(request_form.downcase).to include(request_description.name.downcase)
        end

        private

        def find_request_form_for_patient(_request_forms, patient)
          find("div[data-patient-id='#{patient.id}'][data-role='form_pathology']").text
        end

        def update_request_form_user(user_full_name)
          select user_full_name, from: "User"
          click_on "Update Forms"
        end

        def update_request_form_clinic(clinic_name)
          select clinic_name, from: "Clinic"
          click_on "Update Forms"
        end

        def update_request_form_telephone(telephone)
          fill_in "Telephone", with: telephone
          click_on "Update Forms"
        end
      end
    end
  end
end
