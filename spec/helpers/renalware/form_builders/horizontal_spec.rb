RSpec.describe Renalware::FormBuilders::Horizontal do
  let(:attachment) { build(:patient_attachment) }

  describe "#text_row" do
    it "renders label, control and hint classes" do
      html = helper.form_with(model: attachment, url: "/attachments",
                              builder: described_class) do |f|
        f.text_row(:name, hint: "Used in listings")
      end

      fragment = Nokogiri::HTML.fragment(html)

      expect(fragment.css(".rw-field-row").size).to eq(1)
      expect(fragment.css(".rw-label .rw-label__text").text).to include("Name")
      expect(fragment.css(".rw-control .rw-input").size).to eq(1)
      expect(fragment.css(".rw-hint").text).to include("Used in listings")
    end

    it "renders errors for the field when present" do
      attachment.errors.add(:name, "can't be blank")

      html = helper.form_with(model: attachment, url: "/attachments",
                              builder: described_class) do |f|
        f.text_row(:name)
      end

      fragment = Nokogiri::HTML.fragment(html)

      expect(fragment.css(".rw-error").text).to include("can't be blank")
    end

    it "applies semantic size class when provided" do
      html = helper.form_with(model: attachment, url: "/attachments",
                              builder: described_class) do |f|
        f.text_row(:name, size: :sm)
      end

      fragment = Nokogiri::HTML.fragment(html)
      input = fragment.at_css("input.rw-input")

      expect(input["class"]).to include("rw-input--sm")
    end
  end

  describe "#error_summary" do
    it "renders summary when there are errors" do
      attachment.errors.add(:name, "can't be blank")

      html = helper.form_with(model: attachment, url: "/attachments",
                              builder: described_class, &:error_summary)

      fragment = Nokogiri::HTML.fragment(html)

      expect(fragment.css(".rw-error-summary").size).to eq(1)
      expect(fragment.css(".rw-error-summary__list li").text).to include("Name can't be blank")
    end
  end

  describe "#date_row" do
    it "attaches the flatpickr stimulus controller and formatted value" do
      attachment.document_date = Date.new(2026, 2, 1)

      html = helper.form_with(model: attachment, url: "/attachments",
                              builder: described_class) do |f|
        f.date_row(:document_date)
      end

      fragment = Nokogiri::HTML.fragment(html)
      input = fragment.at_css("input.rw-input")
      icon_wrapper = fragment.at_css(".rw-date-input")
      icon = fragment.at_css(".rw-date-input__icon")
      svg = fragment.at_css(".rw-date-input__icon-svg")

      expect(input["data-controller"]).to eq("flatpickr")
      expect(input["autocomplete"]).to eq("off")
      expect(input["value"]).to be_present
      expect(input["class"]).to include("rw-input--date")
      expect(input["class"]).to include("rw-input--with-icon")
      expect(icon_wrapper).to be_present
      expect(icon).to be_present
      expect(icon["aria-hidden"]).to eq("true")
      expect(svg).to be_present
    end
  end

  describe "#compound_row" do
    it "renders a responsive group of related controls" do
      html = helper.form_with(model: attachment, url: "/attachments",
                              builder: described_class) do |f|
        f.compound_row(label: "Dates", row_class: "dates", controls_class: "sm:grid-cols-2") do
          f.control_group(:document_date, label: "Document date") do
            f.date_control(:document_date)
          end
        end
      end

      fragment = Nokogiri::HTML.fragment(html)
      row = fragment.at_css(".rw-field-row.dates")

      expect(row.at_css(".rw-label__text").text).to eq("Dates")
      expect(row.at_css(".rw-compound-controls")["class"]).to include("sm:grid-cols-2")
      expect(row.at_css(".rw-control-label").text).to eq("Document date")
      expect(row.at_css("input[data-controller='flatpickr']")).to be_present
    end

    it "renders errors beside the relevant control" do
      attachment.errors.add(:document_date, "must be after the start date")

      html = helper.form_with(model: attachment, url: "/attachments",
                              builder: described_class) do |f|
        f.compound_row(label: "Dates") do
          f.control_group(:document_date, label: "Document date") do
            f.date_control(:document_date)
          end
        end
      end

      fragment = Nokogiri::HTML.fragment(html)

      expect(fragment.at_css(".rw-control-group .rw-error").text).to include(
        "must be after the start date"
      )
    end
  end

  describe "#compound_header" do
    it "renders captions aligned to the compound grid, hidden from assistive tech" do
      html = helper.form_with(model: attachment, url: "/attachments",
                              builder: described_class) do |f|
        f.compound_header("Status", "Diagnosed", "Ended", controls_class: "sm:grid-cols-3")
      end

      fragment = Nokogiri::HTML.fragment(html)
      row = fragment.at_css(".rw-field-row--header")

      expect(row["aria-hidden"]).to eq("true")
      expect(row["class"]).to include("hidden").and include("sm:grid")
      expect(row.at_css(".rw-compound-controls")["class"]).to include("sm:grid-cols-3")
      expect(row.css(".rw-control-label").map(&:text)).to eq(%w(Status Diagnosed Ended))
    end
  end

  describe "#control_group" do
    it "hides the label from the sm breakpoint upwards" do
      html = helper.form_with(model: attachment, url: "/attachments",
                              builder: described_class) do |f|
        f.control_group(:name, label: "Name", hide_label: true) do
          f.text_field(:name)
        end
      end

      fragment = Nokogiri::HTML.fragment(html)
      label = fragment.at_css("label")

      expect(label.text).to eq("Name")
      expect(label["class"]).to include("sm:sr-only")
    end
  end

  describe "#radio_group" do
    it "renders an accessible fieldset and checks the current value" do
      attachment.name = "external"
      choices = [%w(Internal internal), %w(External external)]

      html = helper.form_with(model: attachment, url: "/attachments",
                              builder: described_class) do |f|
        f.radio_group(:name, choices, legend: "Storage")
      end

      fragment = Nokogiri::HTML.fragment(html)
      fieldset = fragment.at_css("fieldset.rw-control-group")

      expect(fieldset.at_css("legend").text).to eq("Storage")
      expect(fieldset.css("label.rw-radio-option").map(&:text)).to eq(choices.map(&:first))
      expect(fieldset.at_css("input[value='external']")["checked"]).to eq("checked")
    end

    it "hides the legend from the sm breakpoint upwards" do
      choices = [%w(Internal internal), %w(External external)]

      html = helper.form_with(model: attachment, url: "/attachments",
                              builder: described_class) do |f|
        f.radio_group(:name, choices, legend: "Storage", hide_label: true)
      end

      fragment = Nokogiri::HTML.fragment(html)
      legend = fragment.at_css("legend")

      expect(legend.text).to eq("Storage")
      expect(legend["class"]).to include("sm:sr-only")
    end
  end
end
