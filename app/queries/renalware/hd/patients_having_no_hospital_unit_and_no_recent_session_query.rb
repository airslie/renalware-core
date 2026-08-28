# frozen_string_literal: true

module Renalware
  module HD
    # Select HD patients with no hospital unit and no recent HD session.
    class PatientsHavingNoHospitalUnitAndNoRecentSessionQuery
      def self.call = new.call

      # rubocop:disable-next Metrics/MethodLength
      def call
        result = ActiveRecord::Base.connection.execute(<<~SQL.squish)
          select hds.patient_id, max(hds.started_at) as last_session_at
            from hd_sessions hds
            inner join patients p on p.id  = hds.patient_id
            inner join modality_modalities mm on mm.patient_id = p.id
            inner join modality_descriptions md on md.id = mm.description_id
            left outer join hd_profiles hp on hp.patient_id = p.id and hp.deactivated_at is null
            where
              p.died_on is null
              and hp.hospital_unit_id is null
              and mm.ended_on is null and md.code = 'hd'
            group by hds.patient_id
            having max(hds.started_at) <= ('now'::timestamp - '1 month'::interval);
        SQL
        result
          .values
          .map do |row|
            {
              patient_id: row[0],
              last_session_at: row[1]
            }
          end
      end
    end
  end
end
