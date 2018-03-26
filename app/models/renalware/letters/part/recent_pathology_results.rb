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
        @results ||= begin
          snapshot = letter.pathology_snapshot.dup
          return if snapshot.blank?
          groups = group_snapshot_by_code_and_date(snapshot)
          format_groups_into_string(groups)
        end
      end

      private

      # Note that observation#letter_group determines the group each code falls into,
      # and #letter_order the order codes are displayed within that group., h.g. HGB WBC and PLT
      # are grouped together because they share letter group (1) and within that group the order
      # is determined by letter_order (HGB=1 WBC=2 PLT=3).
      # Results (OBX results) within a groups normally share an observed_at date - ie there is a
      # 1 to 1 relationship between a group and d date output on the letter; most of the time
      # they will arrive in the HL7 feed as part of the same OBR and therefore have the same date.
      # However if, within a group, a code has come in separately with another date, we trigger
      # a new sub group so it gets its own date.
      def group_snapshot_by_code_and_date(snapshot)
        groups = []
        PathologyLayout.new.each_group do |_group_number, obs_descs|
          dates = {}
          obs_descs.each do |obs_desc|
            match = snapshot[obs_desc.code.to_sym]
            next if match.nil?
            next if match[:observed_at].nil?
            date = I18n.l(Date.parse(match[:observed_at]))
            dates[date] ||= {}
            dates[date][obs_desc.code] = match[:result]
          end
          groups << dates
        end
        groups
      end

      def format_groups_into_string(groups)
        str = ""
        groups.each do |group|
          # {"07-Jun-2017"=>{"HGB"=>"10.4", "WBC"=>"3.40", "PLT"=>"435"}}
          group.each do |date, observations|
            observations_string = observations.map{ |code, result| "#{code} #{result}" }.join(", ")
            str += " <span>#{date}</span>: #{observations_string};"
          end
          str = str.strip
        end
        str.html_safe
      end
    end
  end
end
