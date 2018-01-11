require "renalware/letters/part"
require "attr_extras"

# When rendered, the template in `to_partial_path` will be used, and our Part object here will be
# available in the partial as `recent_pathology_results`.
module Renalware
  module Letters
    class Part::RecentPathologyResults < Part
      delegate :each, :any?, :present?, to: :recent_pathology_results

      def to_partial_path
        "renalware/letters/parts/recent_pathology_results"
      end

      def recent_pathology_results
        @recent_pathology_results ||= begin
          letter.pathology_snapshot
          group_snapshot_by_code_and_date(letter.pathology_snapshot)
        end
      end

      private

      # class SnapshotGroupedByDate
      #   pattr_initialize :snapshot

      #   def to_s
      #   end
      # end

      def group_snapshot_by_code_and_date(snapshot)
        snapshot = snapshot_ordered_by_obx_codes_relevant_to_letters(snapshot)

        snapshot_grouped_by_date = group_snapshot_by_date(snapshot)

        format_pathology_string(snapshot_grouped_by_date)
      end

      def snapshot_ordered_by_obx_codes_relevant_to_letters(snapshot)
        RelevantObservationDescription.codes.each_with_object({}) do |code, hash|
          hash[code.to_sym] = snapshot[code.to_sym]
        end
      end

      def group_snapshot_by_date(snapshot)
        current_date = NullObject.instance
        snapshot.each_with_object({}) do |observation, h|
          code, obs = observation
          next if obs.nil?
          date = Time.zone.parse(obs[:observed_at])

          if date != current_date
            current_date = date
            h[date] = []
          end

          h[date] << "#{obx_code_to_name_map[code]} #{obs[:result]}"
        end
      end

      def format_pathology_string(grouped_snapshot)
        str = ""
        grouped_snapshot.each do |date, observations|
          str << "#{I18n.l(date&.to_date)}: #{observations.join(', ')}; "
        end
        str
      end

      def obx_code_to_name_map
        @obx_code_to_name_map ||= begin
          Pathology::ObservationDescription.where(
            code: RelevantObservationDescription.codes
          ).select(:code, :name)
           .each_with_object(HashWithIndifferentAccess.new) do |obx, hash|
            hash[obx.code] = obx.name
          end
        end
      end
    end
  end
end
