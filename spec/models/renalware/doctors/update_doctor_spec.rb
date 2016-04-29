require "rails_helper"

module Renalware::Doctors
  RSpec.describe UpdateDoctor do
    let(:doctor) { create(:doctor) }

    describe "#call" do
      context "given valid doctor attributes" do
        let(:params) { attributes_for(:doctor, given_name: "RABBIT") }

        it "updates the doctor" do
          subject.call(doctor.id, params)

          expect(doctor.reload.given_name).to eq("RABBIT")
        end

        it "notifies a listener the doctor was updated successfully" do
          listener = spy(:listener)
          subject.subscribe(listener)

          subject.call(doctor.id, params)

          expect(listener)
            .to have_received(:update_doctor_successful)
            .with(instance_of(Renalware::Doctor))
        end
      end

      context "give invalid doctor attributes" do
        let(:params) { attributes_for(:doctor, given_name: nil) }

        it "notifies a listener the doctor update failed" do
          listener = spy(:listener)
          subject.subscribe(listener)

          subject.call(doctor.id, params)

          expect(listener)
            .to have_received(:update_doctor_failed)
            .with(instance_of(Renalware::Doctor))
        end
      end
    end
  end
end
