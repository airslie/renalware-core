# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe Letters::ApproveLetter do
    include LettersSpecHelper
    subject(:service) do
      described_class
        .build(letter)
        .broadcasting_to_configured_subscribers
    end

    let(:patient) { create(:letter_patient) }
    let(:user) { create(:user) }
    let(:letter) { create_letter(state: :pending_review, to: :patient, patient: patient) }
    let(:approved_letter) { letter.becomes(Letters::Letter::Approved) }

    it "updates when and by who the letter was approved" do
      time = Time.zone.now
      travel_to(time) do
        service.call(by: user)
      end

      approved_letter.reload
      expect(approved_letter.approved_by).to eq(user)
      expect(approved_letter.approved_at.to_s).to eq(time.to_s)
    end

    describe "broadcasting" do
      it "broadcasts a letter_approved event when the letter is approved successfully" do
        expect {
          service.call(by: user)
        }.to broadcast(:letter_approved, approved_letter)
      end

      describe "async listeners" do
        let(:adapter) { ActiveJob::Base.queue_adapter }

        before do
          ActiveJob::Base.queue_adapter = :test
          ActiveJob::Base.queue_adapter.enqueued_jobs.clear
        end

        it "queues a job to calculate the page size" do
          service.call(by: user)

          expect(Wisper::ActiveJobBroadcaster::Wrapper).to(
            have_been_enqueued.with(
              "Renalware::Letters::CalculatePageCountJob",
              "letter_approved",
              [approved_letter]
            )
          )
        end
      end
    end
  end
end
