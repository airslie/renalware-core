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
                Renalware::Pathology::ObservationDescription.find_by(code: params["id"]).id
              when "Drug" then
                Renalware::Drugs::Drug.find_by(name: params["id"]).id
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
            Renalware::Pathology::RequestDescription.find_by(
              code: params["request_description_code"]
            )
          params["request_description_id"] = request_description.id

          clinic =
            Renalware::Clinics::Clinic.find_by(
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
            expect(required_global_observations).to include(row.first.to_i)
          end
        end
      end

      module Web
        include Domain

        def run_global_algorithm(patient, clinician, regime)
          login_as clinician

          visit patient_pathology_required_observations_path(
            patient_id: patient.id,
            regime: regime
          )

          find_by_id("global_pathology")
            .all("tr")
            .map do |row|
              row.all("th, td").map { |cell| cell.text.strip }
            end
        end

        def expect_observations_from_global(required_global_observations, observations_table)
          expect(required_global_observations).to eq(observations_table.raw)
        end
      end
    end
  end
end
