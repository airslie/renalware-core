# frozen_string_literal: true

require_dependency "renalware/renal"
require "attr_extras"

module Renalware
  module Renal
    class ClinicalSummaryPresenter
      rattr_initialize :patient

      # Host application may override the order or add other summary presenters
      def summary_parts(current_user, params = {})
        Renalware
          .config
          .page_layouts[:clinical_summary]
          .map(&:constantize)
          .map { |klass| klass.new(patient, current_user, params: params) }
          .select(&:render?)
      end
    end
  end
end
