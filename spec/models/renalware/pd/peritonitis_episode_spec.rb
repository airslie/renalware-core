require "rails_helper"

module Renalware
  RSpec.describe PD::PeritonitisEpisode, type: :model do
    include DrugsSpecHelper

    it { is_expected.to validate_presence_of :patient }
    it { is_expected.to validate_presence_of :diagnosis_date }
    it { is_expected.to have_many(:episode_types) }
    it { is_expected.to belong_to(:patient).touch(true) }

    describe "peritonitis episode" do
      before do
        @patient = create(:patient)
        @pe = build(:peritonitis_episode)
        @mrsa = create(:organism_code, name: "MRSA")
        @ecoli = create(:organism_code, name: "E.Coli")
        @user = create(:user)

        load_drugs_by_type("Amoxicillin" => %w(Antibiotic Peritonitis),
                           "Penicillin" => %w(Antibiotic Peritonitis))

        load_med_routes
      end

      context "prescriptions" do
        it "can be assigned many prescriptions and organisms/sensitivities" do
          @prescription_one = create(:prescription,
            patient: @patient,
            drug: @amoxicillin,
            treatable: @pe,
            medication_route: @po,
            frequency: "daily",
            notes: "with food",
            prescribed_on: "02/03/2015",
            provider: 0,
            by: @user
          )

          @prescription_two = create(:prescription,
            patient: @patient,
            drug: @penicillin,
            treatable: @pe,
            medication_route: @iv,
            frequency: "daily",
            notes: "with food",
            prescribed_on: "02/03/2015",
            provider: 1,
            by: @user
          )

          @pe.prescriptions << @prescription_one
          @pe.prescriptions << @prescription_two

          @mrsa_sensitivity = @pe.infection_organisms
                                 .build(organism_code: @mrsa,
                                        sensitivity: "Sensitive to MRSA.")
          @ecoli_sensitivity = @pe.infection_organisms
                                   .build(organism_code: @ecoli,
                                          sensitivity: "Sensitive to E.Coli.")

          @pe.save!
          @pe.reload

          expect(@pe.prescriptions.size).to eq(2)
          expect(@pe.infection_organisms.size).to eq(2)

          expect(@pe.prescriptions).to match_array([@prescription_two, @prescription_one])
          expect(@pe.infection_organisms).to match_array([@ecoli_sensitivity, @mrsa_sensitivity])

          expect(@pe).to be_valid
        end
      end
    end
  end
end
