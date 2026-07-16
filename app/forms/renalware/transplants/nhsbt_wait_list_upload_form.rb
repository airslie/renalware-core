module Renalware
  module Transplants
    class NHSBTWaitListUploadForm
      include ActiveModel::Model
      include ActiveModel::Attributes

      MAX_FILE_SIZE = 10.megabytes

      attribute :file

      validate :file_is_present
      validate :file_is_csv
      validate :file_is_not_too_large

      def filename = file&.original_filename
      def path = file&.path

      private

      def file_is_present
        errors.add(:file, "Please specify a file to upload") if file.blank?
      end

      def file_is_csv
        return if file.blank?
        return if File.extname(filename.to_s).casecmp(".csv").zero?

        errors.add(:file, "must be a CSV file")
      end

      def file_is_not_too_large
        return if file.blank?
        return if file.size <= MAX_FILE_SIZE

        errors.add(:file, "must be less than 10MB")
      end
    end
  end
end
