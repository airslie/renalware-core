require 'rails_helper'

module Renalware
  RSpec.describe PeritonitisEpisode, :type => :model do

    it { should belong_to(:patient) }
    it { should belong_to(:episode_type) }
    it { should belong_to(:fluid_description) }

    it { should have_many(:medications) }
    it { should have_many(:medication_routes).through(:medications) }
    it { should have_many(:patients).through(:medications) }
    it { should have_many(:infection_organisms) }
    it { should have_many(:organism_codes).through(:infection_organisms) }

    it { should accept_nested_attributes_for(:medications) }
    it { should accept_nested_attributes_for(:infection_organisms) }

    it { should validate_presence_of :diagnosis_date }

    describe "peritonitis episode" do

      before do
        @patient = create(:patient)
        @pe = FactoryGirl.build(:peritonitis_episode)
        @mrsa = FactoryGirl.create(:organism_code, name: "MRSA")
        @ecoli = FactoryGirl.create(:organism_code, name: "E.Coli")

        load_drugs_by_type('Amoxicillin' => ['Antibiotic','Peritonitis'],
          'Penicillin' => ['Antibiotic','Peritonitis'])

        load_med_routes
      end

      context "medications" do
        it "can be assigned many medications and organisms/sensitivities" do

          @medication_one = FactoryGirl.create(:medication,
            patient: @patient,
            medicatable: @amoxicillin,
            medicatable_type: "Renalware::Drug",
            treatable: @pe,
            treatable_type: "Renalware::PeritonitisEpisode",
            dose: "20mg",
            medication_route: @po,
            frequency: "daily",
            notes: "with food",
            start_date: "02/03/2015",
            provider: 0,
            deleted_at: "NULL",
            created_at: "2015-02-03 18:21:04",
            updated_at: "2015-02-05 18:21:04"
          )

          @medication_two = FactoryGirl.create(:medication,
            patient: @patient,
            medicatable: @penicillin,
            medicatable_type: "Renalware::Drug",
            treatable: @pe,
            treatable_type: "Renalware::PeritonitisEpisode",
            dose: "20mg",
            medication_route: @iv,
            frequency: "daily",
            notes: "with food",
            start_date: "02/03/2015",
            provider: 1,
            deleted_at: "NULL",
            created_at: "2015-02-03 18:21:04",
            updated_at: "2015-02-05 18:21:04"
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