module Renalware
  module Letters
    describe "renalware/letters/lists/_filters.html.slim" do
      let(:form) { Lists::Form.new(named_filter: :batch_printable) }
      let(:letters) { [instance_double(Renalware::Letters::LetterPresenter)] }

      it "uses the full filtered count in the batch print button label" do
        allow(Renalware.config).to receive(:max_batch_print_size).and_return(2)

        render partial: "renalware/letters/lists/filters",
               locals: {
                 form: form,
                 named_filter: :batch_printable,
                 letters: letters,
                 letters_count: 3
               }

        expect(rendered).to include("Batch print 2 of 3 letters")
      end
    end
  end
end
