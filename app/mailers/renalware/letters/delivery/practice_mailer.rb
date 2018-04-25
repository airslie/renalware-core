# frozen_string_literal: true

require_dependency "renalware/letters"
require "attr_extras"
require_relative "./errors"

module Renalware
  module Letters
    module Delivery
      class PracticeMailer < ApplicationMailer
        def patient_letter(letter:, to:)
          validate_letter(letter)
          letter_presenter = LetterPresenterFactory.new(letter)
          attachments["letter.pdf"] = Letters::PdfRenderer.call(letter_presenter)

          # Note here we render the content in a block so that we can use the locals: {..} syntax
          # which is cleaner than using @vars.
          mail(
            to: to,
            subject: build_subject_for(letter),
            from: Renalware.config.default_from_email_address,
            locals: locals_for(letter)
          ) { |format| format.text { render(locals: locals_for(letter)) } }
        end

        private

        # "$lettdescr from King's Renal Unit (KCH No $hospno1)";
        def build_subject_for(letter)
          renal_unit = Renalware.config.renal_unit_on_letters
          "#{letter.description} from #{renal_unit} #{letter.patient.hospital_identifier}"
        end

        def locals_for(letter)
          {
            help_phone_number: Renalware.config.phone_number_on_letters,
            help_email_address: Renalware.config.default_from_email_address,
            ident_metadata: ident_meta_data_for_insertion_into_body(letter)
          }
        end

        def ident_meta_data_for_insertion_into_body(letter)
          patient = letter.patient
          PracticeEmailMetaData.new(
            letter: letter,
            primary_care_physician: patient.primary_care_physician,
            practice: patient.practice
          )
        end

        def validate_letter(letter)
          raise Delivery::PatientHasNoPracticeError if letter.patient&.practice.blank?
          unless letter.approved? || letter.completed?
            raise Delivery::LetterIsNotApprovedOrCompletedError, letter.id
          end
        end
      end
    end
  end
end
