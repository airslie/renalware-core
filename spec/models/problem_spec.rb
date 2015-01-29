require 'rails_helper'

RSpec.describe Problem, :type => :model do
  it { should belong_to :patient }

  describe "history", :versioning => true do
    before do
      # binding.pry
      @patient = Patient.find_or_create_by!(
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
      before do
        @problem = @patient.problems.create!(description: "I have a problem")
        @problem.update!(description: "I have another problem") 
        @problem.update!(description: "I have more problems")   
      end

      it "should record a patient's history of a problem" do
        expect(@problem.history.map { |x| x.description }).to eq(["I have another problem", "I have a problem"])
      end 
    end

  end

end
