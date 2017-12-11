require "rails_helper"

module Renalware::Pathology
  RSpec.describe UpdateCurrentObservations do
    describe "#call" do
      it "updates the patient's current_observation_set with the incoming "\
         "observations (ie via HL7)" do
        patient = pathology_patient(create(:patient))
        obs_descriptions = [
          create(:pathology_observation_description, code: "HGB"),
          create(:pathology_observation_description, code: "ALB")
        ]

        described_class.new.call(message_params_for(patient, obs_descriptions))
        curr_obs_set = patient.reload.current_observation_set

        expect(curr_obs_set.patient_id).to eq(patient.id)
        values = curr_obs_set.values
        expect(values.keys.sort).to eq(%w(ALB HGB))
        expected_hash = { "result" => "6.0", "observed_at" => "2016-03-04 10:15:40" }
        expect(values["HGB"]).to eq(expected_hash)
        expect(values["ALB"]).to eq(expected_hash)
      end

      context "when the patient already has a particular observation" do
        it "updates it with the new observation" do
          patient = pathology_patient(create(:patient))
          create(:pathology_observation_description, code: "HGB")
          hash = { "result" => "6.0", "observed_at" => "2016-03-04 10:15:40" }
          set = patient.fetch_current_observation_set
          set.values["HGB"] = hash
          set.save!

          new_hash = { "result" => "600.0", "observed_at" => "2017-01-01 10:15:40" }
          set.values["HGB"] = new_hash
          set.save!

          set.reload
          expect(set.values["HGB"]).to eq(new_hash)
          expect(set.values.keys.count).to eq(1)
        end
      end

      # rubocop:disable Metrics/MethodLength
      def message_params_for(patient, obs_descriptions)
        params = {
          patient_id: patient.id,
          observation_request: {
            requestor_order_number: "123",
            requestor_name: "Jane Doe",
            requested_at: "2016-03-04 10:14:49",
            description_id: 99999,
            observations_attributes:  []
          }
        }
        Array(obs_descriptions).each do |desc|
          params[:observation_request][:observations_attributes] << {
            result: "6.0",
            comment: "My Comment",
            observed_at: "2016-03-04 10:15:40",
            description_id: desc.id
          }
        end
        params
      end
      # rubocop:enable Metrics/MethodLength

      def pathology_patient(patient)
        Renalware::Pathology.cast_patient(patient)
      end
    end
  end
end
