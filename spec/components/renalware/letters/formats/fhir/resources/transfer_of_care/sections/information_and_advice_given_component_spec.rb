module Renalware::Letters::Formats::FHIR
  module Resources::TransferOfCare
    describe Sections::InformationAndAdviceGivenComponent, type: :component do
      it do
        letter = nil
        render_inline(described_class.new(letter))

        expect(page).to have_content("InformationAndAdviceGivenComponent")
      end
    end
  end
end
