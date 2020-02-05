# frozen_string_literal: true

require_dependency "renalware/admin"

module Renalware
  module Feeds
    class HL7TestMessagesController < BaseController
      def new
        authorize [:renalware, :admin, :devops], :show?
        test_messages = HL7TestMessage.all
        render locals: { form: HL7TestForm.new, test_messages: test_messages }
      end

      # rubocop:disable Metrics/MethodLength
      def create
        authorize [:renalware, :admin, :devops], :create?
        body = replace_placeholders_in_hl7_message(form_params[:body])
        job = FeedJob.new(body)
        job.perform
        test_patient
        version = test_patient.reload.versions.order(created_at: :desc).last&.object_changes
        json_version = version && JSON.pretty_generate(version)
        respond_to do |format|
          format.js do
            render locals: {
              a: "asas",
              test_patient: test_patient,
              version: json_version
            }
          end
        end
        # rubocop:enable Metrics/MethodLength

        # # Delayed::Job.enqueue job
        # redirect_to(
        #   renalware.new_feeds_hl7_test_message_path,
        #   notice: "Hl7 message queued"
        # )
      end

      private

      def form_params
        params.require(:feeds_hl7_test_form).permit(:body)
      end

      def test_patient
        @test_patient ||= Patient.find_by!(local_patient_id: "Z100001")
      end

      def replace_placeholders_in_hl7_message(message)
        message
          .gsub("{{message_id}}", SecureRandom.hex(12))
          .gsub("{{local_patient_id}}", test_patient.local_patient_id)
          .gsub("\r\n", "\r")
      end
    end
  end
end
