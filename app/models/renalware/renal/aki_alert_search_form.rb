# frozen_string_literal: true

require_dependency "renalware/renal"

module Renalware
  module Renal
    class AKIAlertSearchForm
      include ActiveModel::Model
      include Virtus::Model

      attribute :date, Date
      attribute :hospital_unit_id, Integer
      attribute :hospital_ward_id, Integer
      attribute :action, String
      attribute :term, String
      attribute :on_hotlist, String
      attribute :s, String
      attribute :named_filter, String

      # rubocop:disable Metrics/MethodLength
      def query
        @query ||= begin
          options = {
            created_at_casted_date_equals: date,
            identity_match: term,
            hospital_ward_id_eq: hospital_ward_id,
            hospital_ward_hospital_unit_id_eq: hospital_unit_id,
            action_id_eq: action,
            hotlist_eq: on_hotlist,
            s: s,
            named_filter: named_filter
          }
          AKIAlertQuery.new(options)
        end
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
