require 'rails_helper'

module Renalware
  RSpec.describe PeritonitisEpisode, :type => :model do
    include DrugsSpecHelper

    it { should validate_presence_of :patient }
    it { should validate_presence_of :diagnosis_date }

    describe "peritonitis episode" do

      before do
        @patient = create(:patient)
        @pe = build(:peritonitis_episode)
        @mrsa = create(:organism_code, name: "MRSA")
        @ecoli = create(:organism_code, name: "E.Coli")
        @user = create(:user)

        load_drugs_by_type('Amoxicillin' => ['Antibiotic','Peritonitis'],
          'Penicillin' => ['Antibiotic','Peritonitis'])

        load_med_routes
      end

      context "medications" do
        it "can be assigned many medications and organisms/sensitivities" do

          @medication_one = create(:medication,
            patient: @patient,
            drug: @amoxicillin,
            treatable: @pe,
            dose: "20mg",
            medication_route: @po,
            frequency: "daily",
            notes: "with food",
            start_date: "02/03/2015",
            provider: 0,
            by: @user
          )

          @medication_two = create(:medication,
            patient: @patient,
            drug: @penicillin,
            treatable: @pe,
            dose: "20mg",
            medication_route: @iv,
            frequency: "daily",
            notes: "with food",
            start_date: "02/03/2015",
            provider: 1,
            by: @user
          )

          @pe.medications << @medication_one
          @pe.medications << @medication_two

          @mrsa_sensitivity = @pe.infection_organisms.build(organism_code: @mrsa, sensitivity: "Sensitive to MRSA.")
          @ecoli_sensitivity = @pe.infection_organisms.build(organism_code: @ecoli, sensitivity: "Sensitive to E.Coli.")

          @pe.save!
          @pe.reload

          expect(@pe.medications.size).to eq(2)
          expect(@pe.infection_organisms.size).to eq(2)

          expect(@pe.medications).to match_array([@medication_two, @medication_one])
          expect(@pe.infection_organisms).to match_array([@ecoli_sensitivity, @mrsa_sensitivity])

          expect(@pe).to be_valid
        end
      end

    end

  end
end
