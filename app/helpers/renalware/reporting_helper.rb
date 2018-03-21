# frozen_string_literal: true

module Renalware
  module ReportingHelper
    def audits_breadcrumb
      breadcrumb_for("Audits", reporting_audits_path)
    end
  end
end
