# frozen_string_literal: true

require "renalware/letters"

module Renalware
  module Letters
    # Given a hash of letter section classes (i.e. the class names for each Part that should be
    # included in the letter, where each Part is responsible for rendering a section of the letter)
    # and other options, this class filters out certain sections based on conditions,
    # for example if a site does not want pathology, the recent_pathology_results key is
    # removed from the hash.
    class PartClassFilter
      pattr_initialize [:sections!, :include_pathology_in_letter_body!]

      def filter
        remove_recent_observations_section_if_no_pathology_required_in_body(sections)
      end

      private

      # Some sites may not require pathology in letters. This is determined by the boolean
      # #include_pathology_in_letter_body flag on the letterhead, which is site-specific.
      # TODO: It might be better to link the letterhead to the Hospitals::Site and
      # put the site-specific configuration in say a jsonb field on the Site.
      def remove_recent_observations_section_if_no_pathology_required_in_body(section_klasses)
        unless include_pathology_in_letter_body
          section_klasses = section_klasses.reject { |klass|
            klass.identifier == :recent_pathology_results
          }
        end
        section_klasses
      end
    end
  end
end
