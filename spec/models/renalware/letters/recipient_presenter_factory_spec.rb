require "rails_helper"

module Renalware
  module Letters
    RSpec.describe RecipientPresenterFactory, type: :model do
      include LettersSpecHelper

      subject(:presenter_factory) { RecipientPresenterFactory }

      let(:patient) { build(:letter_patient) }

      describe ".new" do
        %w(draft ready_for_review archived).each do |state|
          context "given the letter is in state #{state}" do
            let(:letter) { build_letter(to: :patient, patient: patient) }

            before { allow(letter).to receive(:state).and_return(state) }

            it "returns the presenter class for the #{state} state" do
              presenter = presenter_factory.new(letter.main_recipient)

              presenter_class = RecipientPresenter.const_get(state.classify)
              expect(presenter).to be_a(presenter_class)
            end
          end
        end
      end
    end
  end
end
