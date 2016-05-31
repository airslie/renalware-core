module World
  module Pathology
    module PatientAlgorithm
      module Domain
        # @section commands
        #
        def create_patient_rule(params)
          params["last_observed_at"] = str_to_time(params["last_observed_at"])
          params["patient"] = Renalware::Pathology.cast_patient(params["patient"])
          params["lab"] = Renalware::Pathology::Lab.find_by(name: params["lab"])

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

        def run_patient_algorithm(patient, _clinician)
          pathology_patient = Renalware::Pathology.cast_patient(patient)

          Renalware::Pathology::RequestAlgorithm::Patient.new(pathology_patient)
            .determine_required_tests
        end

        # @section expectations
        #
        def expect_observations_from_patient(required_patient_observations, observations_table)
          observations_table.rows.each do |row|
            expect(required_patient_observations.map(&:test_description)).to include(row[1])
          end
        end
      end

      module Web
        include Domain

        def run_patient_algorithm(patient, clinician)
          login_as clinician

          visit patient_pathology_required_observations_path(
            patient_id: patient.id
          )

          html_table_to_array("patient_pathology")
        end

        def expect_observations_from_patient(algorithm, observations_table)
          expect(algorithm).to eq(observations_table.raw)
        end
      end
    end
  end
end
