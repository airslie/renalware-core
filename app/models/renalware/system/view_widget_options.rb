module Renalware
  module System
    # Backed by Jsonb, stored in view_metadata.widget_options.
    class ViewWidgetOptions
      include StoreModel::Model

      IDENTIFIER_REGEX = /\A[a-z_][a-z0-9_]*\z/
      MAX_ROWS_LIMIT = 100

      attribute :max_rows, :integer, default: 5
      attribute :patient_id_column, :string
      attribute :order_by, :string
      attribute :order_direction, :string, default: "desc"
      attribute :empty_state, :string, default: "No data"
      attribute :slots, array: true, default: -> { [] }

      validates :max_rows, numericality: {
        only_integer: true,
        greater_than: 0,
        less_than_or_equal_to: MAX_ROWS_LIMIT
      }
      validates :patient_id_column, format: { with: IDENTIFIER_REGEX }, allow_blank: true
      validates :order_by, format: { with: IDENTIFIER_REGEX }, allow_blank: true
      validates :order_direction, inclusion: { in: %w(asc desc) }

      def scoped_to_patient?
        patient_id_column.present?
      end

      def visible_in_slot?(slot)
        slots.include?(slot)
      end
    end
  end
end
