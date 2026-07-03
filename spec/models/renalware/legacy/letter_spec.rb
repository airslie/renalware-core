# frozen_string_literal: true

module Renalware
  module Legacy
    describe Letter do
      describe "#letter_body_text" do
        around do |example|
          original = Renalware.config.legacy_letters_body_selector
          example.run
        ensure
          Renalware.config.legacy_letters_body_selector = original
        end

        it "extracts the configured body element from the legacy HTML" do
          letter = described_class.new(
            letter_html: "<html><body><div id=\"letter_text_body\">Body text</div></body></html>"
          )

          expect(letter.letter_body_text).to eq("<div id=\"letter_text_body\">Body text</div>")
        end

        it "falls back to the BLT body element when a configured body element is not present" do
          Renalware.config.legacy_letters_body_selector = ".future-hospital-letter-body"
          letter = described_class.new(
            letter_html: "<html><body><div id=\"letter_text_body\">Body text</div></body></html>"
          )

          expect(letter.letter_body_text).to eq("<div id=\"letter_text_body\">Body text</div>")
        end

        it "falls back to the full legacy HTML when the configured body element is not present" do
          letter = described_class.new(letter_html: "<p>Full letter</p>")

          expect(letter.letter_body_text).to eq("<p>Full letter</p>")
        end
      end
    end
  end
end
