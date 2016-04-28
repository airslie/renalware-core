require "rails_helper"

module Renalware
  module Letters
    RSpec.describe ReviseLetter, type: :model do
      let(:letter) { create(:letter, :to_patient) }
      let(:patient) { letter.patient }

      describe ".call" do
        it "assigns attributes to the letter" do
          stub_persistancy

          subject.call(patient, letter.id, description: "Foo")
            .on(:revise_letter_successfull) do |letter|
              expect(letter.description).to eq("Foo")
            end
        end

        it "persists the letter" do
          expect(PersistLetter).to receive(:build).and_return(double.as_null_object)

          subject.call(patient, letter.id)
        end

        context "when letter is persisted" do
          it "broadcasts :revise_letter_successfull" do
            stub_persistancy

            expect_subject_to_broadcast(:revise_letter_successful, instance_of(Letter))

            subject.call(patient, letter.id)
          end
        end

        context "when letter cannot be persisted" do
          it "broadcasts :revise_letter_failed" do
            service = double
            allow(service).to receive(:call).and_raise(ActiveRecord::RecordInvalid.new(Letter.new))
            allow(PersistLetter).to receive(:build).and_return(service)

            expect_subject_to_broadcast(:revise_letter_failed, instance_of(Letter))

            subject.call(patient, letter.id)
          end
        end
      end

      def stub_persistancy
        allow(PersistLetter).to receive(:build).and_return(double.as_null_object)
      end

      def expect_subject_to_broadcast(*args)
        expect(subject).to receive(:broadcast).with(*args)
      end
    end
  end
end