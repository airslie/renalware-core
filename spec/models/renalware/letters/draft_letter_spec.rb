require "rails_helper"

module Renalware
  module Letters
    RSpec.describe DraftLetter, type: :model do
      let(:patient) { create(:letter_patient, cc_on_all_letters: false) }
      let(:persist_letter) { spy }

      subject { DraftLetter.new(persist_letter) }

      describe ".call" do
        it "sets up the letter" do
          subject.call(patient, description: "Foo")
            .on(:draft_letter_successfull) do |letter|
              expect(letter.description).to eq("Foo")
            end
        end

        it "persists the letter" do
          expect(persist_letter).to receive(:call)

          subject.call(patient)
        end

        context "when letter is persisted" do
          it "notifies a listener the letter was drafted successfully" do
            listener = spy(:listener)
            subject.subscribe(listener)

            subject.call(patient)

            expect(listener)
              .to have_received(:draft_letter_successful).with(instance_of(Letter))
          end
        end

        context "when letter cannot be persisted" do
          it "notifies a listener the drafting the letter failed" do
            allow(persist_letter)
              .to receive(:call).and_raise(ActiveRecord::RecordInvalid.new(Letter.new))

            listener = spy(:listener)
            subject.subscribe(listener)

            subject.call(patient)

            expect(listener).to have_received(:draft_letter_failed).with(instance_of(Letter))
          end
        end
      end
    end
  end
end