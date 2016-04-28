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

        it " broadcasts :doctor_updated" do
          expect_subject_to_broadcast(:doctor_updated, instance_of(Renalware::Doctor))

          subject.call(doctor.id, params)
        end
      end

      context "give invalid doctor attributes" do
        let(:params) { attributes_for(:doctor, given_name: nil) }

        it " broadcasts :doctor_update_failed" do
          expect_subject_to_broadcast(:doctor_update_failed, instance_of(Renalware::Doctor))

          subject.call(doctor.id, params)
        end
      end
    end

    def expect_subject_to_broadcast(*args)
      expect(subject).to receive(:broadcast).with(*args)
    end
  end
end
