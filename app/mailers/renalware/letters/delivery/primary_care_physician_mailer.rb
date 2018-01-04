require_dependency "renalware/letters"
require "attr_extras"

module Renalware
  module Letters
    module Delivery
      class LetterRecipientMissingAddresseeError < StandardError; end
      class AddresseeIsNotAPrimaryCarePhysicianError < StandardError; end
      class PatientHasNoPracticeError < StandardError; end
      class PrimaryCarePhysicianDoesNotBelongToPatientsPracticeError < StandardError; end
      class PracticeHasNoEmailError < StandardError; end

      class PrimaryCarePhysicianMailer < ApplicationMailer
        def patient_letter(*args)
          options = PatientLetterOptions.new(*args)
          options.validate

          letter_presenter = LetterPresenterFactory.new(options.letter)

          attachments["letter.pdf"] = PdfLetterCache.fetch(letter_presenter) do
            # No cache hit so render and return the PDF content which will be stored in the cache
            Letters::PdfRenderer.call(options.letter)
          end

          mail(to: options.practice_email, subject: "Test")
        end

        class PatientLetterOptions
          attr_reader_initialize :letter, :gp_recipient
          delegate :patient, to: :letter
          delegate :practice, to: :patient
          delegate :email, to: :practice, prefix: true
          delegate :addressee, to: :gp_recipient
          alias :primary_care_physician :addressee

          # rubocop:disable Metrics/AbcSize
          def validate
            raise LetterRecipientMissingAddresseeError if addressee.blank?
            raise AddresseeIsNotAPrimaryCarePhysicianError unless addressee.respond_to?(:practices)
            raise PatientHasNoPracticeError if practice.blank?
            raise PracticeHasNoEmailError if practice.email.blank?
            unless primary_care_physician.practices.include?(practice)
              raise PrimaryCarePhysicianDoesNotBelongToPatientsPracticeError
            end
          end
          # rubocop:enable Metrics/AbcSize
        end
      end
    end
  end
end
