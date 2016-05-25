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
          ccs = super + determine_counterpart_ccs
          ::CollectionPresenter.new(ccs, RecipientPresenterFactory)
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
    end
  end
end
