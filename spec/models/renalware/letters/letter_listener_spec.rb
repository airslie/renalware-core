require "rails_helper"

module Renalware
  describe Letters::LetterListener do
    subject(:listener) { described_class.new }

    describe "receives a broadcast 'letter_approved' message" do
      it "delegates to DeliverLetter, passing the letter" do
        letter = instance_double(Letters::Letter)
        deliver_letter = instance_double(Letters::Delivery::DeliverLetter, call: nil)
        allow(Letters::Delivery::DeliverLetter).to receive(:new).and_return(deliver_letter)

        listener.letter_approved(letter)

        expect(deliver_letter).to have_received(:call)
      end
    end
  end
end
