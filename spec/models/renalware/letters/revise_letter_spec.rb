require "rails_helper"

module Renalware
  module Letters
    RSpec.describe ReviseLetter, type: :model do
      include LettersSpecHelper

      let(:letter) { create_letter_to(:patient) }
      let(:patient) { letter.patient }
      let(:persist_letter) { spy }

      subject { ReviseLetter.new(persist_letter) }

      describe ".call" do
        it "assigns attributes to the letter" do
          subject.call(patient, letter.id, description: "Foo")
            .on(:revise_letter_successfull) do |letter|
              expect(letter.description).to eq("Foo")
            end
        end

        it "persists the letter" do
          expect(persist_letter).to receive(:call)

          subject.call(patient, letter.id)
        end

        context "when letter is persisted" do
          it "notifies a listener the letter was revised successfully" do
            listener = spy(:listener)
            subject.subscribe(listener)

            subject.call(patient, letter.id)

            expect(listener)
              .to have_received(:revise_letter_successful)
              .with(instance_of(Letter))
          end
        end

        context "when letter cannot be persisted" do
          it "notifies a listener the revising the letter failed" do
            allow(persist_letter).to receive(:call)
              .and_raise(ActiveRecord::RecordInvalid.new(Letter.new))

            listener = spy(:listener)
            subject.subscribe(listener)

            subject.call(patient, letter.id)

            expect(listener)
              .to have_received(:revise_letter_failed)
                .with(instance_of(Letter))
          end
        end
      end
    end
  end
end