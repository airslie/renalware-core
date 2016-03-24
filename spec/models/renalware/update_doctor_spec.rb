require "rails_helper"

module Renalware
  describe UpdateDoctor do
    describe "#call" do
      context "for an unsaved Doctor" do
        it "creates a new Doctor record" do
          expect {
            UpdateDoctor.new.call(doctor_params.merge(address: create(:address)))
          }.to change(Doctor, :count).by(1)
        end

        it "assigns practices based on practice_ids params" do
          practice = create(:practice)
          expect {
            UpdateDoctor.new.call(doctor_params.merge(practice_ids: [practice.to_param]))
          }.to change(practice.doctors, :count).by(1)
        end
      end

      context "for an existing Doctor" do
        before do
          @doctor = create(:doctor, given_name: "John", family_name: "Merrill")
        end

        it "updates the existing record" do
          UpdateDoctor.new(@doctor).call(doctor_params)

          expect(@doctor.reload.given_name).to eq("Barry")
          expect(@doctor.family_name).to eq("Foster")
        end

        it "updates the existing practices" do
          practice = create(:practice)

          UpdateDoctor.new(@doctor).call(doctor_params.merge(practice_ids: [practice.to_param]))

          expect(@doctor.reload.practices).to include(practice)
        end
      end
    end
  end
end

def doctor_params
  {
    given_name: "Barry",
    family_name: "Foster",
    email: "barry.foster@nhs.net",
    code: "GP98765",
    practitioner_type: "GP"
  }
end

def address_params
  { street_1: "123 South Street", postcode: "N1 1NN" }
end
