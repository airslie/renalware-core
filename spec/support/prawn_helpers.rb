# frozen_string_literal: true

module PrawnHelpers
  require "tempfile"
  require "pdf-reader"

  def pdf_reader_from(prawn_doc)
    file = Tempfile.new("pdf")
    prawn_doc.render_file file
    PDF::Reader.new(file)
  end

  def test_prawn_doc
    Prawn::Document.new(
      page_size: "A4",
      page_layout: :portrait,
      margin: 15
    )
  end

  def default_test_arg_values # rubocop:disable Metrics/MethodLength
    {
      provider: :generic,
      version: 1,
      modality: "HD",
      telephone: "",
      hospital_number: nil,
      nhs_number: nil,
      consultant: nil,
      postcode: nil,
      hospital_department: nil,
      hospital_telephone: nil,
      prescriber_name: nil,
      po_number: "134",
      administration_device: nil,
      given_name: "John",
      family_name: "SMITH",
      title: "Mr",
      no_known_allergies: true,
      allergies: [],
      drug_type: :esa,
      born_on: "2019-01-01",
      prescription_date: "2019-01-01"
    }.dup
  end

  def extract_text_from_prawn_doc(doc)
    pdf_reader_from(doc).pages.map(&:text).join
  end
end
