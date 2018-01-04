require_dependency "renalware/letters"
require_relative "./errors"
require "attr_extras"

module Renalware
  module Letters
    module Delivery
      class PrimaryCarePhysicianMailer < ApplicationMailer
        default from: ->{ Renalware.config.default_from_email_address }

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

          # In development or staging etc, if allow_external_mail is false, we intercept mail
          # and sent it to the user who last updated the relevant record, for instance to the user
          # that approved a letter
          def practice_email
            Renalware.config.allow_external_mail ? practice.email : letter.updated_by.email
          end
        end
      end
    end
  end
end
