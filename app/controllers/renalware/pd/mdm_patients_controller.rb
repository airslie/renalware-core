# frozen_string_literal: true

require "renalware/pd"

module Renalware
  module PD
    class MDMPatientsController < Renalware::MDMPatientsController
      def index
        render_index(query: query,
                     page_title: t(".page_title"),
                     view_proc: ->(patient) { patient_pd_mdm_path(patient) })
      end

      def query
        @query ||= begin
          MDMPatientsQuery.new(
            relation: policy_scope(PD::Patient),
            q: params[:q],
            named_filter: named_filter
          )
        end
      end

      def named_filter
        params[:named_filter]
      end
    end
  end
end
