# frozen_string_literal: true

require "renalware/letters/part"
require "attr_extras"

# When rendered, the template in `to_partial_path` will be used, and our Part object here will be
# available in the partial as `recent_pathology_results`.
module Renalware
  module Letters
    class Part::RecentPathologyResults < Part
      delegate :each, :any?, :present?, to: :results

      def to_partial_path
        "renalware/letters/parts/recent_pathology_results"
      end

      def results
        @recent_pathology_results ||= begin
          snapshot = letter.pathology_snapshot
          return if snapshot.blank?
          group_snapshot_by_code_and_date(snapshot)
        end
      end

      private

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

          h[date] << "#{code} #{obs[:result]}"
        end
      end

      def format_pathology_string(grouped_snapshot)
        str = "".dup
        grouped_snapshot.each do |date, observations|
          str << "#{I18n.l(date&.to_date)}: #{observations.join(', ')}; "
        end
        str.strip
      end
    end
  end
end
