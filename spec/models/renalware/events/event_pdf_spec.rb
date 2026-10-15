require "pdf/reader"

module Renalware::Events
  describe EventPdf do
    describe "#render" do
      let(:symbols) { "≥ ≤ → ↑ µ" }
      let(:event) { EventPdfPresenter.new(create(:simple_event)) }
      let!(:hospital_centre) { create(:hospital_centre, code: Renalware.config.ukrdc_site_code) }

      def rendered_text
        PDF::Reader.new(StringIO.new(described_class.call(event))).pages.map(&:text).join("\n")
      end

      it "generates a PDF" do
        expect(described_class.new(event).render).to start_with "%PDF-1.3"
      end

      it "preserves clinical symbols and paragraph breaks in notes" do
        event.notes = "First: #{symbols}<br><br>Second: #{symbols}"

        expect(rendered_text).to match(/First: #{symbols}\n\s*\nSecond: #{symbols}/)
        expect(event.notes).to eq("First: #{symbols}<br><br>Second: #{symbols}")
      end

      it "preserves clinical symbols in descriptions and structured fields" do
        event.description = "Description: #{symbols}"
        allow(event).to receive(:document).and_return(
          Renalware::Events::Swab::Document.new(location: "Location: #{symbols}")
        )

        expect(rendered_text).to include("Description: #{symbols}", "Location: #{symbols}")
      end

      it "preserves clinical symbols in every inline font style" do
        hospital_centre.update!(info: <<~HTML.squish)
          Normal: #{symbols}<br>
          <b>Bold: #{symbols}</b><br>
          <i>Italic: #{symbols}</i><br>
          <b><i>Both: #{symbols}</i></b>
        HTML

        expect(rendered_text).to include(
          "Normal: #{symbols}", "Bold: #{symbols}", "Italic: #{symbols}", "Both: #{symbols}"
        )
      end

      it "does not embed the fallback font for Windows-1252 text" do
        event.notes = "Creatinine 100 µmol/L"

        pdf = described_class.call(event)

        expect(pdf).to include("/BaseFont /Helvetica")
        expect(pdf).not_to include("/FontFile2")
      end

      it "embeds a subset of the fallback font when clinical symbols require it" do
        event.notes = symbols

        reader = PDF::Reader.new(StringIO.new(described_class.call(event)))
        fonts = reader.pages.first.fonts.values.pluck(:BaseFont)

        expect(fonts).to include(:Helvetica)
        expect(fonts.map(&:to_s)).to include(match(/\A[0-9a-f]{6}\+DejaVuSans\z/))
      end
    end

    it "raises for Japanese text outside the current fallback font's coverage" do
      event = EventPdfPresenter.new(create(:simple_event, notes: "日本語"))
      create(:hospital_centre, code: Renalware.config.ukrdc_site_code)

      expect {
        described_class.call(event)
      }.to raise_error(Prawn::Errors::IncompatibleStringEncoding)
    end
  end
end
