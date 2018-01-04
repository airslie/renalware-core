require_dependency "renalware/letters"
require_relative "./errors"
require "attr_extras"

module Renalware
  module Letters
    module Delivery
      class PrimaryCarePhysicianMailer < ApplicationMailer
        default from: ->{ Renalware.config.default_from_email_address }

        def patient_letter(letter)
          options = PatientLetterOptions.new(letter)
          options.validate

          letter_presenter = LetterPresenterFactory.new(letter)
          attachments["letter.pdf"] = read_from_cache_or_generate_pdf_letter(letter_presenter)

          mail(
            to: options.practice_email,
            subject: "Test",
            from: Renalware.config.default_from_email_address
          )
        end

        def read_from_cache_or_generate_pdf_letter(letter)
          PdfLetterCache.fetch(letter) { Letters::PdfRenderer.call(letter) }
        end

        # Note that while there is an addressee attribute on Recipient, it is only used if the
        # Recipient#person_role == :contact. Otherwise we are able to look up the correct person
        # using person_role - for example finding the patient's GP if the person_role
        # is :primary_care_physician
        class PatientLetterOptions
          attr_reader_initialize :letter
          delegate :patient, to: :letter
          delegate :practice, :primary_care_physician, to: :patient

          # rubocop:disable Metrics/AbcSize
          def validate
            raise PatientHasNoPracticeError if practice.blank?
            raise PatientHasNoPrimaryCarePhysicianError if primary_care_physician.blank?
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
