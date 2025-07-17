# frozen_string_literal: true

RSpec.describe Forms::Fresenius::Homecare::DeliveryDetailsTable do
  it "generates a PDF" do
    args = Forms::Homecare::Args.new(**default_homecare_args)
    doc = test_prawn_doc

    described_class.new(doc, args).build

    extract_text_from_prawn_doc(doc)

    # expect(text).to ...
  end
end
