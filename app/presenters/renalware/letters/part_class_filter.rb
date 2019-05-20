# frozen_string_literal: true

require "renalware/letters"
require "attr_extras"

module Renalware
  module Letters
    # Given a hash of letter part classes (i.e. the class names for each Part that should be
    # included in the letter, where each Part is responsible for rendering a part of the letter)
    # and other options, this class filters out certain parts based on conditions,
    # for example if a site does not want pathology, the recent_pathology_results key is
    # removed from the hash.
    class PartClassFilter
      pattr_initialize [:part_classes!, :include_pathology_in_letter_body!]

      def to_h
        filtered_part_classes
      end

      private

      def filtered_part_classes
        remove_recent_observations_part_if_no_pathology_required_in_body(part_classes)
      end

      # Some sites may not require pathology in letters. This is determined by the boolean
      # #include_pathology_in_letter_body flag on the letterhead, which is site-specific.
      # TODO: It might be better to link the letterhead to the Hospitals::Site and
      # put the site-specific configuration in say a jsonb field on the Site.
      def remove_recent_observations_part_if_no_pathology_required_in_body(part_klasses)
        unless include_pathology_in_letter_body
          part_klasses = part_klasses.reject { |key| key == :recent_pathology_results }
        end
        part_klasses
      end
    end
  end
end
