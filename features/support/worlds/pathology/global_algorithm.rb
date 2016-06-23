module World
  module Pathology
    module GlobalAlgorithm
      module Domain
        # @section commands
        #
        def create_global_rule(params)
          param_id =
            case params["type"]
              when "ObservationResult" then
                Renalware::Pathology::ObservationDescription.find_by!(code: params["id"]).id
              when "Drug" then
                Renalware::Drugs::Drug.find_by!(name: params["id"]).id
            end

          Renalware::Pathology::RequestAlgorithm::GlobalRule.create!(
            global_rule_set_id: params["global_rule_set_id"],
            param_type: params["type"],
            param_id: param_id,
            param_comparison_operator: params["operator"],
            param_comparison_value: params["value"]
          )
        end

        def create_global_rules_from_table(table)
          table.rows.map do |row|
            params = Hash[table.headers.zip(row)]
            params["global_rule_set_id"] = @rule_set.id
            create_global_rule(params)
          end
        end

        def create_global_rule_set(params)
          request_description =
            Renalware::Pathology::RequestDescription.find_by!(
              code: params["request_description_code"]
            )
          params["request_description_id"] = request_description.id

          clinic =
            Renalware::Clinics::Clinic.find_by!(
              name: params["clinic"]
            )
          params["clinic"] = clinic

          Renalware::Pathology::RequestAlgorithm::GlobalRuleSet.create!(
            params.except("request_description_code")
          )
        end

        def run_global_algorithm(patient, _clinician, clinic_name)
          pathology_patient = Renalware::Pathology.cast_patient(patient)
          clinic = Renalware::Clinics::Clinic.find_by(name: clinic_name)

          Renalware::Pathology::RequestAlgorithm::Global.new(pathology_patient, clinic)
            .determine_required_request_descriptions
        end

        # @section expectations
        #
        def expect_observations_from_global(required_global_observations, observations_table)
          observations_table.rows.each do |row|
            request_description = Renalware::Pathology::RequestDescription.find_by!(code: row.first)
            expect(required_global_observations).to include(request_description)
          end
        end
      end

      module Web
        include Domain

        def run_global_algorithm(patient, clinician, clinic_name)
          login_as clinician
          save_and_open_page
          clinic = Renalware::Clinics::Clinic.find_by(name: clinic_name)

          visit patient_pathology_required_observations_path(
            patient_id: patient.id,
            clinic_id: clinic.id
          )

          html_table_to_array("global_pathology")
        end

        def expect_observations_from_global(required_global_observations, observations_table)
          expect(required_global_observations).to eq(observations_table.raw)
        end
      end
    end
  end
end
