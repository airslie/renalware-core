# frozen_string_literal: true

require_dependency "renalware/patients"

module Renalware
  module Patients
    #
    # An Attachment is file of some kind linked to a patient.
    # How and where the file is stored depends on the #store_file_externally boolean on
    # attachment#attachment_type.
    #
    # attachment_type#store_file_externally == true
    #   we validate that the external_location field is present, as this is assumed to be the path
    #   to the file on a network share for instance.
    #   We don't care whether it is a real path or where it is - the user enters it manually.
    #
    # attachment_type#store_file_externally == false
    #   we validate that the ActiveStorage #file attachment is uploaded (and not too big).
    #
    class Attachment < ApplicationRecord
      include Accountable
      acts_as_paranoid

      belongs_to :patient, touch: true
      belongs_to :attachment_type, class_name: "Renalware::Patients::AttachmentType"
      has_one_attached :file

      validates :patient, presence: true
      validates :attachment_type, presence: true
      validates :file, presence: true
      validates :name, presence: true
      validates :external_location, presence: { if: -> { attachment_type&.store_file_externally } }
      validate :validate_uploaded_file_size
      validate :validate_presence_of_file_if_attachment_type_indicates_it_should_be_uploaded

      # The user may have selected the file to upload, then changed the atachment_type to one that
      # has store_file_externally = true, thus hiding the file input, but the file still gets sent.
      def discard_uploaded_file_if_attachment_type_suggests_external_storage
        if file.attached? && attachment_type.store_file_externally?
          file.purge
        end
      end

      private

      def validate_uploaded_file_size
        max = Renalware.config.max_file_upload_size
        if file.attached? && file.blob.byte_size > max
          file.purge
          errors[:file] << "Sorry, the file is too large. The maximum is #{max} bytes."
        end
      end

      def validate_presence_of_file_if_attachment_type_indicates_it_should_be_uploaded
        return if attachment_type.blank?

        if !file.attached? && attachment_type.store_file_internally?
          errors[:file] << "Please specify a file to upload"
        end
      end
    end
  end
end
