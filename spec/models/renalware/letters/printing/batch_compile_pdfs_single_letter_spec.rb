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

      it "does not create a blank pdf when the single letter has no printable recipients" do
        batch = Letters::Batch.create!(by: user)
        letter = create_approved_letter_to_emailed_gp
        batch.items.create!(letter: letter)
        expected_batch_pdf = Renalware.config.base_working_folder.join(
          "batched_letters",
          "#{batch.id}.pdf"
        )
        FileUtils.rm_f(expected_batch_pdf)

        Dir.mktmpdir(nil, Rails.root.join("tmp").to_s) do |dir|
          Dir.chdir(dir) do
            described_class.call(batch, user)

            expect(File).not_to exist("compiled_letter_#{letter.id}.pdf")
          end
        end

        expect(File).not_to exist(expected_batch_pdf)
      end

      def create_approved_letter_to_emailed_gp
        letter = create_letter(
          state: :approved,
          to: :primary_care_physician,
          patient: patient_not_ccd_on_letters,
          page_count: 1
        )
        letter.main_recipient.update!(emailed_at: Time.zone.now)
        letter
      end

      def patient_not_ccd_on_letters
        create(
          :letter_patient,
          cc_on_all_letters: false,
          practice: create(:practice, email: "practice@example.com"),
          primary_care_physician: create(:letter_primary_care_physician)
        )
      end
    end
  end
end
