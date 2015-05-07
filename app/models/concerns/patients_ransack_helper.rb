require 'active_support/concern'

module PatientsRansackHelper
  extend ActiveSupport::Concern

  included do
    class_eval do
      scope :identity_match, -> (identity=1) {
        term = sanitize_identity_query(identity)
        where(identity_sql, {fuzzy_term: "%#{term}%", exact_term: term})
      }
    end
  end

  class_methods do
    def ransackable_scopes(auth=nil)
      %i(identity_match)
    end

    private

    def sanitize_identity_query(query)
      query.gsub(',','')
    end

    def identity_sql
      <<-SQL.squish
        local_patient_id = :exact_term OR
        nhs_number = :exact_term OR
        forename ILIKE :fuzzy_term OR
        surname ILIKE :fuzzy_term OR
        CONCAT(surname, ' ', forename) ILIKE :fuzzy_term
      SQL
    end
  end
end
