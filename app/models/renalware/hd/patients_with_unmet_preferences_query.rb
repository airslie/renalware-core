require_dependency "renalware/hd"

module Renalware
  module HD
    class PatientsWithUnmetPreferencesQuery

      def call
        HD::Patient
          .eager_load(:hd_profile)
          .eager_load(:hd_preference_set)
          .where(where_clause)
      end

      private

      def where_clause
        <<-SQL.squish
          (hd_preference_sets.hospital_unit_id > 0 AND
            hd_profiles.hospital_unit_id != hd_preference_sets.hospital_unit_id) OR
          (coalesce(hd_preference_sets.schedule, '') != '' AND
            hd_profiles.schedule != hd_preference_sets.schedule) OR
          (coalesce(hd_preference_sets.other_schedule, '') != '' AND
            hd_profiles.other_schedule != hd_preference_sets.other_schedule)
        SQL
      end
    end
  end
end
