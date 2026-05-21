module Renalware
  module System
    class SqlViewWidgetComponent < ApplicationComponent
      rattr_initialize [:view_metadata!, patient: nil, patient_scope: nil, current_user: nil]

      delegate :empty_state, to: :widget_options

      def rows
        @rows ||= SqlViewWidgetQuery.call(relation.limit(widget_options.max_rows))
      end

      def title
        view_metadata.title.presence || view_metadata.view_name.humanize
      end

      private

      def relation
        @relation ||= begin
          rel = sql_view_klass.all
          rel = patient_scoped_relation(rel)
          rel = ordered_relation(rel)
          rel
        end
      end

      def patient_scoped_relation(rel)
        return rel unless widget_options.scoped_to_patient?

        validate_column!(widget_options.patient_id_column)

        if patient.present?
          rel.where(widget_options.patient_id_column => patient.id)
        elsif patient_scope.present?
          rel.where(widget_options.patient_id_column => patient_scope.select(:id))
        else
          rel.none
        end
      end

      def ordered_relation(rel)
        return rel if widget_options.order_by.blank?

        validate_column!(widget_options.order_by)

        rel.order(
          sql_view_klass
            .arel_table[widget_options.order_by]
            .public_send(widget_options.order_direction)
        )
      end

      def validate_column!(column_name)
        return if sql_view_klass.column_names.include?(column_name)

        raise(
          ArgumentError,
          "#{column_name} is not a column on #{view_metadata.fully_qualified_view_name}"
        )
      end

      def sql_view_klass
        @sql_view_klass ||=
          Reporting::SqlView
            .new(view_metadata.fully_qualified_view_name)
            .klass
            .tap(&:reset_column_information)
      end

      def widget_options
        view_metadata.widget_options
      end
    end
  end
end
