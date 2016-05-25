require_dependency "renalware/letters"
require "collection_presenter"

module Renalware
  module Letters
    class LetterPresenter < DumbDelegator
      def patient
        @patient_presenter ||= PatientPresenter.new(super)
      end

      def main_recipient
        @main_recipient_presenter ||= RecipientPresenterFactory.new(super)
      end

      def cc_recipients
        @cc_recipients_with_counterparts ||= begin
          recipients = build_cc_recipients
          present_cc_recipients(recipients)
        end
      end

      def description
        "(#{letterhead.site_code}) #{super}"
      end

      def electronic_signature
        [
          "ELECTRONICALLY SIGNED BY #{author.full_name}",
          "on #{::I18n.l updated_at}"
        ].join("<br>").html_safe
      end

      private

      # Include the counterpart cc recipients (i.e. patient and/or doctor)
      def build_cc_recipients
        __getobj__.cc_recipients + determine_counterpart_ccs
      end

      def present_cc_recipients(recipients)
        ::CollectionPresenter.new(recipients, RecipientPresenterFactory)
      end
    end
  end
end
