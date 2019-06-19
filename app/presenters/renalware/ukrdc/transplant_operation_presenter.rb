# frozen_string_literal: true

require_dependency "renalware/transplants"
require "attr_extras"

module Renalware
  module UKRDC
    class TransplantOperationPresenter
      SNOMED_KIDNEY = { code: "70536003​", name: "Kidney Transplant" }.freeze
      SNOMED_PANCREAS = { code: "62438007​", name: "Pancreas Transplant" }.freeze
      SNOMED_KIDNEY_PANCREAS = { code: "6471000179103​", name: "Kidney Transplant" }.freeze

      PROCEDURE_SNOMED_MAP = {
        kidney: SNOMED_KIDNEY,
        kidney_dual: SNOMED_KIDNEY,
        kidney_pancreas: SNOMED_KIDNEY_PANCREAS,
        pancreas: SNOMED_PANCREAS,
        kidney_liver: SNOMED_KIDNEY,
        liver: SNOMED_KIDNEY
      }.freeze

      pattr_initialize :operation
      delegate_missing_to :operation
      delegate :code, :name, to: :hospital_centre, prefix: true, allow_nil: true

      def procedure_type_snomed_code
        PROCEDURE_SNOMED_MAP.fetch(operation_type.to_sym)[:code]
      end

      def procedure_type_name
        PROCEDURE_SNOMED_MAP.fetch(operation_type.to_sym)[:name]
      end
    end
  end
end
