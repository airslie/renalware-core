require 'rails_helper'

RSpec.describe PeritonitisEpisode, :type => :model do
  it { should belong_to :patient }

  it { should have_many(:infection_organisms) }
  it { should have_many(:organism_codes).through(:infection_organisms) }

  context "medication routes" do
    before do
      @patient = FactoryGirl.create(:patient,
        nhs_number: "1000124505",
        local_patient_id: "Z999988",
        surname: "Jones",
        forename: "Jack",
        dob: "01/01/1988",
        paediatric_patient_indicator: "0",
        sex: 1,
        ethnicity_id: 1
      )

      @pe = PeritonitisEpisode.new
    end

    it "should have five medication routes" do        
      expect(@pe).not_to be_valid

      medication_route = MedicationRoute.new

      5.times do
        @pe.medication_routes << medication_route
      end

      expect(@pe).to be_valid
    end

    it "should be of type MedicationRoute" do
      expect{ @pe.medication_routes << nil }.to raise_error(ActiveRecord::AssociationTypeMismatch)
    end

  end
end
