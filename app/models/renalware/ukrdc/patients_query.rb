# frozen_string_literal: true

require_dependency "renalware/ukrdc"

module Renalware
  module UKRDC
    # If the optional :changed_since argument is passed we select all RPV
    # patients how have been updated since that date. Otherwise we select all RPV
    # patients who have changed since the last time they were exported.
    # A patient has a sent_to_ukrdc_at datetime which is the last time the data was actually sent.
    # It maybe be that something about the patient has changed and updated_at > sent_to_ukrdc_at
    # however when compiled to xml there are no effective changes, for example because some notes
    # were added somewhere on the patient's data but those notes don't make it into the XML. So
    # therefore no effective changes and we don't send the file to UKRDC.
    # However a downside of this approach is that we always find updated patients and generate
    # an XML for them, in order to compare an MD5 hash of the XML with what was previously sent, and
    # *sometimes* this is waste of time if the MD5 hash has not changed. However we will live with
    # this for now I think. If it is a problem we can use the checked_for_ukrdc_changes_at column
    # on patients.
    class PatientsQuery
      def call(changed_since: nil)
        if changed_since.present?
          rpv_patients.where("updated_at > ?", changed_since)
        else
          rpv_patients.where("(sent_to_ukrdc_at is null) or (updated_at > sent_to_ukrdc_at)")
        end
      end

      private

      def rpv_patients
        Renalware::Patient.where(send_to_rpv: true)
      end
    end
  end
end
