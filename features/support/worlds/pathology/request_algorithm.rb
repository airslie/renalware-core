require "array_stringifier"

module World
  module Pathology
    module RequestAlgorithm
      module Domain
        # @section commands

        def create_patient_rule(params)
          # Convert "5 days ago" to a Time object
          last_tested_matches =
            params["last_tested_at"]
            .match(/^(?<num>\d+) (?<time_unit>day|days|week|weeks) ago$/)

          if last_tested_matches
            params["last_tested_at"] =
              Time.now - last_tested_matches[:num].to_i.send(last_tested_matches[:time_unit].to_sym)
          end

          Renalware::Pathology::RequestAlgorithm::PatientRule.create!(params)
        end

        def create_global_rule(params)
          Renalware::Pathology::RequestAlgorithm::GlobalRule.create!(params)
        end

        def create_global_rule_set(params)
          Renalware::Pathology::RequestAlgorithm::GlobalRuleSet.create!(params)
        end

        def run_global_algorithm(patient, regime)
          Renalware::Pathology::RequestAlgorithm::Global.new(patient, regime)
        end

        def run_patient_algorithm(patient)
          Renalware::Pathology::RequestAlgorithm::Patient.new(patient)
        end

        # @section expectations
        #
        def expect_observations_from_global(algorithm, observations_table)
          observations_table.rows.each do |row|
            expect(@global_algorithm.required_pathology).to include(row.first.to_i)
          end
        end

        def expect_observations_from_patient(algorithm, observations_table)
          observations_table.rows.each do |row|
            expect(algorithm.required_pathology.map(&:id)).to include(row.first.to_i)
          end
        end
      end
    end
  end
end
