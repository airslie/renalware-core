# frozen_string_literal: true

module Renalware
  module Feeds
    # Legacy RTF letter filename format: A_B_C_D_E_F.rtf
    #   A = MRN (Hosp No) or UNKNOWN
    #   B = DOB as YYYYMMDD or UNKNOWN
    #   C = POSTCODE as XXX-XXX or UNKNOWN
    #   D = NHS No or UNKNOWN
    #   E = Letter Topic (should be "GP LETTER" if GP = recip or CC"? check with Stan)
    #   F = Letter timestamp YYYYMMDDHHMM
    class RTFLetterFilename
      pattr_initialize :letter

      EXTENSION = ".rtf"
      MAX_FILENAME_LENGTH = 100
      MAX_HOSPITAL_NUMBER_LENGTH = 10
      MAX_POSTCODE_LENGTH = 8
      DATE_LENGTH = 8
      NHS_NUMBER_LENGTH = 10
      TIMESTAMP_LENGTH = 14
      MISSING_PLACEHOLDER = "UNKNOWN"
      SEPARATOR = "_"
      SEPARATOR_COUNT = 5
      MAX_TOPIC_LENGTH = MAX_FILENAME_LENGTH -
                         EXTENSION.length -
                         SEPARATOR_COUNT -
                         MAX_HOSPITAL_NUMBER_LENGTH -
                         DATE_LENGTH -
                         MAX_POSTCODE_LENGTH -
                         NHS_NUMBER_LENGTH -
                         TIMESTAMP_LENGTH

      def to_s
        filename
      end

      private

      def filename
        "#{filename_parts.join(SEPARATOR)}#{EXTENSION}"
      end

      def filename_parts
        patient_parts = PatientFilenameParts.new(letter.patient)
        letter_parts = LetterFilenameParts.new(letter)
        issued_on = letter_parts.issued_on
        prefix_parts = patient_filename_parts(patient_parts)
        topic = truncate_topic(letter_parts.topic)

        [*prefix_parts, topic, issued_on]
      end

      def patient_filename_parts(patient_parts)
        [
          patient_parts.hospital_number,
          patient_parts.dob,
          patient_parts.postcode,
          patient_parts.nhs_number
        ]
      end

      def truncate_topic(topic)
        topic[0, MAX_TOPIC_LENGTH] || ""
      end

      class LetterFilenameParts
        INVALID_CHARS_REMOVE = "%$`@#\"?*<>:|"
        INVALID_CHARS_MAP_TO_SPACE = %w(/ \\).join

        pattr_initialize :letter

        def issued_on
          skip_seconds = ENV.fetch("RTF_LETTER_FILENAME_TS_SKIP_SECONDS", 0).to_i == 1
          format = skip_seconds ? "%Y%m%d%H%M" : "%Y%m%d%H%M%S"
          letter.approved_at.strftime(format)
        end

        def topic
          letter
            .topic
            .text
            .tr(INVALID_CHARS_REMOVE, "")
            .tr(INVALID_CHARS_MAP_TO_SPACE, " ")
            .strip
        end
      end

      class PatientFilenameParts
        pattr_initialize :patient

        def hospital_number
          patient.local_patient_id.presence || MISSING_PLACEHOLDER
        end

        def dob
          patient.born_on&.strftime("%Y%m%d").presence || MISSING_PLACEHOLDER
        end

        def postcode
          patient.current_address&.postcode&.tr(" ", "-").presence || MISSING_PLACEHOLDER
        end

        def nhs_number
          patient.nhs_number.presence || MISSING_PLACEHOLDER
        end
      end
    end
  end
end
