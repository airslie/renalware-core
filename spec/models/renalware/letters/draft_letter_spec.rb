require "rails_helper"

module Renalware
  module Letters
    RSpec.describe DraftLetter, type: :model do
      let(:patient) { create(:letter_patient, cc_on_all_letters: false) }

      describe ".call" do
        it "sets up the letter" do
          stub_persistancy

          subject.call(patient, description: "Foo")
            .on(:draft_letter_successfull) do |letter|
              expect(letter.description).to eq("Foo")
            end
        end

        it "persists the letter" do
          expect(PersistLetter).to receive(:build).and_return(double.as_null_object)

          subject.call(patient)
        end

        context "when letter is persisted" do
          it "notifies a listener the letter was drafted successfully" do
            stub_persistancy

            listener = spy(:listener)
            subject.subscribe(listener)

            subject.call(patient)

            expect(listener).to have_received(:draft_letter_successful).with(instance_of(Letter))
          end
        end

        context "when letter cannot be persisted" do
          it "notifies a listener the drafting the letter failed" do
            service = double
            allow(service).to receive(:call).and_raise(ActiveRecord::RecordInvalid.new(Letter.new))
            allow(PersistLetter).to receive(:build).and_return(service)

            listener = spy(:listener)
            subject.subscribe(listener)

            subject.call(patient)

            expect(listener).to have_received(:draft_letter_failed).with(instance_of(Letter))
          end
        end
      end

      def stub_persistancy
        allow(PersistLetter).to receive(:build).and_return(double.as_null_object)
      end
    end
  end
end