# frozen_string_literal: true

module Renalware
  module System
    # Information on SQL views used to build parts of the UI
    class ViewMetadata < ApplicationRecord
      has_paper_trail(
        versions: { class_name: "Renalware::System::Version" },
        on: [:create, :update, :destroy]
      )

      attribute :columns, ColumnDefinition.to_array_type
      validates :columns, store_model: true

      attribute :filters, FilterDefinition.to_array_type
      validates :filters, store_model: true

      # This maps to a PG enum
      enum display_type: { tabular: "tabular" }
      enum category: { mdm: "mdm", report: "report" }

      scope :refreshable_materialised_views, lambda {
        where(materialized: true).where.not(refresh_schedule: [nil, ""])
      }

      def fully_qualified_view_name
        [schema_name, view_name].reject(&:blank?).join(".")
      end
    end
  end
end
