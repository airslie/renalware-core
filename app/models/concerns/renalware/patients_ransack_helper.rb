require "active_support/concern"

module Renalware
  module PatientsRansackHelper
    extend ActiveSupport::Concern

    included do
      class_eval do
        scope :identity_match, -> (identity=1) {
          where(sql_and_params(identity))
        }
      end
    end

    class_methods do
      def ransackable_scopes(auth=nil)
        %i(identity_match)
      end

      private

      def sanitize_query!(query)
        query.delete!(",")
      end

      def sql_and_params(query)
        sanitize_query!(query)

        if query.include?(" ")
          [full_name_sql, full_name_params(query)]
        else
          [identity_sql, identity_params(query)]
        end
      end

      def identity_params(query)
        { fuzzy_term: "#{query}%", exact_term: query }
      end

      def identity_sql
        <<-SQL.squish
          local_patient_id = :exact_term OR
          nhs_number = :exact_term OR
          family_name ILIKE :fuzzy_term
        SQL
      end

      def full_name_params(query)
        family_name, forename = query.split(" ")
        { family_name: "#{family_name}%", forename: "#{forename}%" }
      end

      def full_name_sql
        <<-SQL.squish
          family_name ILIKE :family_name AND
          forename ILIKE :forename
        SQL
      end
    end
  end
end
