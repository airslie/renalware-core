# frozen_string_literal: true

module Renalware
  module HD
    module QueryablePatient
      extend ActiveSupport::Concern
      included do
        # Using a custom ransacker to be able to order by access plan create_at
        # becuase I believe using an implcit :access_plan_create_at in the sort_link
        # will not work because there is no belongs_to access_plan on HD::Patient
        # and even adding a custom join to access_plans as we do, Ransack will not resolve
        # :access_plans_created_at. Still this seens a reasonable solution.
        # We mix this module into HD::Patient at runtime.
        ransacker :access_plan_date, type: :date do
          Arel.sql("coalesce(access_plans.created_at, '1900-01-01'::timestamp)")
        end

        ransacker :access_plan_type, type: :string do
          Arel.sql("access_plan_types.name")
        end

        ransacker :current_access, type: :string do
          Arel.sql("access_plan_types.name")
        end
      end
    end

    class MDMPatientsQuery
      include ModalityScopes
      include PatientPathologyScopes
      MODALITY_NAMES = "HD"
      DEFAULT_SEARCH_PREDICATE = "hgb_date desc"
      ACCESS_JOINS = <<-SQL.squish
        left outer join access_plans on access_plans.patient_id = patients.id
        and access_plans.terminated_at is null
        left outer join access_plan_types
        on access_plans.plan_type_id = access_plan_types.id
        left outer join access_profiles on access_profiles.patient_id = patients.id
        and access_profiles.terminated_on is not null
        and access_profiles.started_on <= current_date
        left outer join access_types on access_types.id = access_profiles.type_id
      SQL
      attr_reader :q

      def initialize(q:)
        @q = q || {}
        @q[:s] = DEFAULT_SEARCH_PREDICATE if @q[:s].blank?
      end

      def call
        search.result
      end

      def search
        @search ||= begin
          HD::Patient
            .include(QueryablePatient)
            .joins(ACCESS_JOINS)
            .eager_load(hd_profile: [:hospital_unit])
            .extending(ModalityScopes)
            .extending(PatientPathologyScopes)
            .with_current_pathology
            .with_current_modality_matching(MODALITY_NAMES)
            .search(q)
        end
      end
    end
  end
end
