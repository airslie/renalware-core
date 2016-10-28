require "rails_helper"

module Renalware
  RSpec.describe PD::ExitSiteInfection, type: :model do
    include DrugsSpecHelper

    it { should validate_presence_of :patient }
    it { should validate_presence_of :diagnosis_date }

    describe "exit site infection" do
      before do
        @patient = create(:patient)
        @es = build(:exit_site_infection)
        @lymphocytes = create(:organism_code, name: "Lymphocytes")
        @proteus = create(:organism_code, name: "Proteus")
        @user = create(:user)

        load_drugs_by_type("Cephradine" => ["Antibiotic","Peritonitis"],
                           "Dicloxacillin" => ["Antibiotic","Peritonitis"])

        load_med_routes
      end

      context "prescriptions" do
        it "can be assigned many prescriptions and organisms/sensitivities" do

          @prescription_one = create(:prescription,
            patient: @patient,
            drug: @cephradine,
            treatable: @es,
            medication_route: @im,
            frequency: "daily",
            notes: "with food",
            prescribed_on: "02/03/2015",
            provider: 1,
            by: @user
          )

          @prescription_two = create(:prescription,
            patient: @patient,
            drug: @dicloxacillin,
            treatable: @es,
            medication_route: @sc,
            frequency: "daily",
            notes: "with food",
            prescribed_on: "02/03/2015",
            provider: 1,
            by: @user
          )

          @lymphocytes_sensitivity = @es.infection_organisms
                                        .build(organism_code: @lymphocytes,
                                               sensitivity: "Sensitive to Lymphocytes.")
          @proteus_sensitivity = @es.infection_organisms
                                    .build(organism_code: @proteus,
                                           sensitivity: "Sensitive to Proteus.")

          @es.prescriptions << @prescription_one
          @es.prescriptions << @prescription_two

          @es.save!
          @es.reload

          expect(@es.prescriptions.size).to eq(2)
          expect(@es.infection_organisms.size).to eq(2)

          expect(@es.prescriptions).to match_array([@prescription_two, @prescription_one])
          expect(@es.infection_organisms).to match_array(
            [
              @proteus_sensitivity,
              @lymphocytes_sensitivity
            ])

          expect(@es).to be_valid
        end
      end

    end
  end
end
