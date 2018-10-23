# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Letters
    describe LetterPresenter do
      subject(:presenter) { described_class.new(letter) }

      let(:patient) { instance_double(Patient, local_patient_id: "A123", family_name: "Jones") }
      let(:letter) { instance_double(Letter, patient: patient, id: 111, state: :draft) }

      describe "#pdf_filename" do
        it "returns a formatted filename inclusing the letter state" do
          expect(presenter.pdf_filename).to eq("JONES-A123-111-DRAFT.pdf")
        end
      end

      describe "#pdf_stateless_filename" do
        it "returns a formatted filename exluding the letter state" do
          expect(presenter.pdf_stateless_filename).to eq("JONES-A123-111.pdf")
        end
      end
    end
  end
end
