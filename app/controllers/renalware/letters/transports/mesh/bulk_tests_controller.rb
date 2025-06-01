module Renalware
  module Letters
    module Transports::Mesh
      class BulkTestsController < BaseController
        include Broadcasting

        def create
          return unless Rails.env.development?

          authorize Transmission, :create?

          patient = Renalware::Patient.find_by!(nhs_number: "9691375087")
          comment = "Bulk test at @#{Time.zone.now}"

          # The idea here is to create > 500 mesh responses so that we can test that fetch in
          # blocks of 500 and will keep polling until the inbox is empty.
          # 260 will generate 520 responses which is more than the 500 limit - an INF and BUS
          # response for each send.
          100.times do |index|
            letter = create_letter_for(patient)
            transmission = Transmission.create!(letter: letter, comment: "#{comment} #{index}")
            transmission.reload
            SendMessageJob.perform_now(transmission)
          end
        end

        private

        # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        def create_letter_for(patient)
          patient = patient.becomes(Letters::Patient)
          draft_letter = LetterFactory.new(
            patient,
            clinical: true,
            author: current_user,
            letterhead: Letterhead.first,
            topic: Topic.first,
            description: "sss",
            by: current_user
          ).build
          draft_letter.save!
          draft_letter = patient.letters.draft.find(draft_letter.id)
          letter_pending_review = draft_letter.submit(by: current_user)
          letter_pending_review.save!
          letter_pending_review = patient.letters.pending_review.find(letter_pending_review.id)

          ApproveLetter
            .new(letter_pending_review)
            .call(by: current_user)

          patient.letters.approved.find(draft_letter.id)
        end
        # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
      end
    end
  end
end
