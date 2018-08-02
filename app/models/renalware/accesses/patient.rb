# frozen_string_literal: true

require_dependency "renalware/accesses"

module Renalware
  module Accesses
    class Patient < ActiveType::Record[Renalware::Patient]
      has_many :profiles, dependent: :destroy
      has_many :plans, dependent: :destroy
      has_many :procedures, dependent: :destroy
      has_many :assessments, dependent: :destroy

      def current_profile
        profiles.current.first
      end

      def current_plan
        plans.current.first
      end

      scope :with_current_plan, lambda {
        joins(<<-SQL)
          left outer join access_plans on access_plans.patient_id = patients.id
            and access_plans.terminated_at is null
          left outer join access_plan_types
            on access_plans.plan_type_id = access_plan_types.id
        SQL
      }

      scope :with_profile, lambda {
        joins(<<-SQL)
          left outer join access_profiles on access_profiles.patient_id = patients.id
            and access_profiles.terminated_on is not null
            and access_profiles.started_on <= current_date
          left outer join access_types on access_types.id = access_profiles.type_id
        SQL
      }

      scope :with_profile, lambda {
        with_current_plan
      }
    end
  end
end
