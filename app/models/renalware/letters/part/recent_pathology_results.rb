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
          snapshot = letter.pathology_snapshot&.dup
          return if snapshot.blank?
          group_snapshot_by_code_and_date(snapshot)
        end
      end

      private

      def group_snapshot_by_code_and_date(snapshot)
        hash = map_snapshot_into_new_hash_keyed_by_observation_date(snapshot)
        hash = sort_each_dates_codes_by_obx_precedence(hash)
        format_pathology_string(hash)
      end

      # We start with e.g.
      # {
      #  "NA": {
      #    "result": "137",
      #    "observed_at": "2018-03-12T13:56:00"
      #  }
      #  "ABC": {
      #    "result": "123",
      #    "observed_at": "2018-03-12T13:56:00"
      #  },...
      # }
      # and map to:
      # {
      #   "2018-03-12": {
      #     "NA": "137",
      #     "ABC": "123"
      #   }
      # }
      def map_snapshot_into_new_hash_keyed_by_observation_date(snapshot)
        snapshot.each_with_object({}) do |arr, hash|
          key, value = arr
          result = value[:result]
          observed_at_date = Time.zone.parse(value[:observed_at]).to_date
          date_key = I18n.l(observed_at_date)
          hash[date_key] ||= {}
          hash[date_key][key] = result
        end
      end

      def sort_each_dates_codes_by_obx_precedence(hash)
        # Sort hash by date so we get e.g.
        #   {"02-Feb-2018"=>{:CCA=>"2.24", :CRE=>"221", :PHOS=>"0.85"}}
        hash = hash.sort_by{ |key, _v| Date.parse(key) }.reverse # newest first
        # now sort each dates codes by OBX precedence
        hash.each_with_object({}) do |arr, new_hash|
          key, results = arr
          new_hash[key] = results.sort_by do |obx_code_key, _result|
            RelevantObservationDescription.codes.find_index(obx_code_key.to_s.upcase)
          end
        end
      end

      def format_pathology_string(grouped_snapshot)
        str = ""
        grouped_snapshot.each do |date, observations|
          observations_string = observations.map{ |x| x.join(" ") }.join(", ")
          str += "#{I18n.l(date&.to_date)}: #{observations_string}; "
        end
        str.strip
      end
    end
  end
end
