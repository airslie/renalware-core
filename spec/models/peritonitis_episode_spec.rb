require 'rails_helper'

RSpec.describe PeritonitisEpisode, :type => :model do
  it { should belong_to :patient }

  describe "history", :versioning => true do
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
    end

    context "display all history of problems " do

      it "should record a patient's history of a problem" do
      end
    end

  end

end
