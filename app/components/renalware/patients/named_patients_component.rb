# frozen_string_literal: true

module Renalware
  module Patients
    class NamedPatientsComponent < ApplicationComponent
      include ApplicationHelper
      include Pagy::Backend
      include Pagy::Frontend

      delegate :default_patient_link, to: :helpers
      pattr_initialize [:current_user!]

      def render?
        patients.count > 0
      end

      def pagination
        load_patients unless @pagination
        @pagination
      end

      def patients
        load_patients unless @patients
        @patients
      end

      def formatted_title(title)
        if pagination.items < pagination.count
          "#{title} (#{pagination.items} of #{pagination.count})"
        else
          "#{title} (#{pagination.count})"
        end
      end

      private

      def load_patients
        @pagination, @patients = pagy(scope, items: 10, link_extra: "data-remote='true'")
      end

      def scope
        Patient
          .merge(Accesses::Patient.with_current_plan)
          .merge(Accesses::Patient.with_profile)
          .merge(HD::Patient.with_profile)
          .extending(PatientPathologyScopes)
          .with_current_pathology
          .includes(current_modality: :description)
          .where(named_nurse: current_user)
          .order(updated_at: :desc)
      end
    end
  end
end
