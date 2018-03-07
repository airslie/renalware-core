require_dependency "renalware/renal"

module Renalware
  module Renal
    class AKIAlertSearchForm
      include ActiveModel::Model
      include Virtus::Model

      attribute :hospital_unit_id, Integer
      attribute :hospital_ward_id, Integer
      attribute :action, String
      attribute :term, String
      attribute :on_hotlist, String
      attribute :s, String

      def query
        @query ||= begin
          options = {
            identity_match: term,
            hospital_ward_id_eq: hospital_ward_id,
            hospital_ward_hospital_unit_id_eq: hospital_unit_id,
            action_id_eq: action,
            hotlist_eq: on_hotlist,
            s: s
          }
          AKIAlertQuery.new(options)
        end
      end
    end
  end
end
