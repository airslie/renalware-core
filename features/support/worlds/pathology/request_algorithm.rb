module World
  module Pathology
    module RequestAlgorithm
      module Domain
        # @section helpers
        #

        # Convert "5 days ago" to a Time object
        def str_to_time(last_observed_at)
          last_tested_matches =
            last_observed_at.match(/^(?<num>\d+) (?<time_unit>day|days|week|weeks) ago$/)

          if last_tested_matches
            last_tested_matches[:num].to_i.public_send(last_tested_matches[:time_unit]).ago
          end
        end

        # @section commands
        #
        def create_patient_rule(params)
          params["last_observed_at"] = str_to_time(params["last_observed_at"])
          params["patient"] = Renalware::Pathology.cast_patient(params["patient"])

          Renalware::Pathology::RequestAlgorithm::PatientRule.create!(params)
        end

        def update_patient_rule_start_end_dates(patient_rule, within_rage)
          params =
            if within_rage == "yes"
              {
                start_date: Date.current - 1.days,
                end_date: Date.current + 1.days
              }
            else
              {
                start_date: Date.current - 2.days,
                end_date: Date.current - 1.days
              }
            end

            patient_rule.update_attributes!(params)
        end

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

          Renalware::Pathology::RequestAlgorithm::GlobalRuleSet.create!(
            params.except("request_description_code")
          )
        end

        def run_global_algorithm(patient, regime)
          Renalware::Pathology::RequestAlgorithm::Global.new(patient, regime).required_pathology
        end

        def run_patient_algorithm(patient)
          Renalware::Pathology::RequestAlgorithm::Patient.new(patient).required_pathology
        end

        # @section expectations
        #
        def expect_observations_from_global(required_global_observations, observations_table)
          observations_table.rows.each do |row|
            expect(required_global_observations).to include(row.first.to_i)
          end
        end

        def expect_observations_from_patient(required_patient_observations, observations_table)
          observations_table.rows.each do |row|
            expect(required_patient_observations.map(&:id)).to include(row.first.to_i)
          end
        end
      end
    end
  end
end
