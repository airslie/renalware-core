require 'rails_helper'

RSpec.describe PatientProblem, :type => :model do
  it { should belong_to :patient }

  describe "history", :versioning => true do
    before do
      # binding.pry
      @patient = FactoryGirl.create(:patient)
    end

    context "display all history of problems " do
      before do
        @problem = @patient.patient_problems.create!(description: "I have a problem")
        @problem.update!(description: "I have another problem") 
        @problem.update!(description: "I have more problems")   
      end

      it "should record a patient's history of a problem" do
        expect(@problem.history.map { |x| x.description }).to eq(["I have another problem", "I have a problem"])
      end 
    end

  end

end
