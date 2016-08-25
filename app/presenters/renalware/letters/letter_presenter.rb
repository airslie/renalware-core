require_dependency "renalware/letters"
require "collection_presenter"

module Renalware
  module Letters
    class LetterPresenter < DumbDelegator
      def type
        letter_event.to_s
      end

      def patient
        @patient_presenter ||= PatientPresenter.new(super)
      end

      def event_description
        letter_event.description
      end

      def main_recipient
        @main_recipient_presenter ||= recipient_presenter_class.new(super)
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

      def view_label
        "Preview"
      end

      def parts
        letter_event.part_classes.values.map {|part_class| part_class.new(patient, letter_event) }
      end

      def part_for(part_name)
        letter_event.part_classes[part_name].new(patient, letter_event)
      end

      def content
        if archived?
          archive.content
        else
          @content ||= HTMLRenderer.new.call(self)
        end
      end

      def pdf_filename
        [patient.family_name, patient.local_patient_id, id, state].join("-").upcase
      end

      private

      # Include the counterpart cc recipients (i.e. patient and/or doctor)
      def build_cc_recipients
        __getobj__.cc_recipients + determine_counterpart_ccs
      end

      def present_cc_recipients(recipients)
        ::CollectionPresenter.new(recipients, recipient_presenter_class)
      end

      def recipient_presenter_class
        RecipientPresenter
      end

      # @section sub-classes

      class Draft < LetterPresenter
        private

        def recipient_presenter_class
          RecipientPresenter::WithCurrentAddress
        end
      end

      class PendingReview < LetterPresenter
        private

        def recipient_presenter_class
          RecipientPresenter::WithCurrentAddress
        end
      end

      class Approved < LetterPresenter
        def view_label
          "View"
        end
      end
    end
  end
end
