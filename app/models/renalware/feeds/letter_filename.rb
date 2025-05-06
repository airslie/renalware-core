module Renalware
  module Feeds
    class LetterFilename
      pattr_initialize :renderable

      delegate :patient,
               :external_document_type_code,
               to: :renderable

      def to_s
        [
          patient.hospital_identifiers.all.map { |k, v| "#{k}_#{v}" }.join("_"),
          patient.family_name&.upcase,
          patient.born_on&.strftime("%Y%m%d"),
          external_document_type_code,
          renderable.id
        ].compact.join("_")
      end
    end
  end
end
