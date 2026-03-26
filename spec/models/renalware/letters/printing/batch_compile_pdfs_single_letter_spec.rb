require "pdf/reader"

module Renalware
  module Letters
    describe Printing::BatchCompilePdfs do
      include LettersSpecHelper

      let(:user) { create(:user) }

      it "creates a batch pdf when the batch contains a single letter" do
        batch = Letters::Batch.create!(by: user)
        letter = create_approved_letter_to_patient_with_cc_to_gp_and_one_contact(page_count: 1)
        batch.items.create!(letter: letter)

        Dir.mktmpdir(nil, Rails.root.join("tmp").to_s) do |dir|
          Dir.chdir(dir) do
            described_class.call(batch, user)
          end
        end

        expect(batch.reload.status).to eq("awaiting_printing")
        expect(batch.filepath).to be_present
        expect(File).to exist(batch.filepath)
        expect(PDF::Reader.new(batch.filepath).page_count).to eq(12)
      end
    end
  end
end
