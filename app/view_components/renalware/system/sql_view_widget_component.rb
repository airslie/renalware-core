module Renalware
  module System
    class SqlViewWidgetComponent < ApplicationComponent
      rattr_initialize [:view_metadata!, patient: nil, current_user: nil]

      delegate :empty_state, to: :widget_options

      def rows
        @rows ||= relation.limit(widget_options.max_rows).to_a
      end

      def columns
        @columns ||= begin
          attribute_names = sql_view_klass.columns.map(&:name) - %w(id secure_id document)
          attribute_names = (view_metadata.columns.map(&:code) + attribute_names).uniq

          attribute_names.filter_map do |attr|
            column_definition_for(attr).then { |column| column unless column.hidden }
          end
        end
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
        return rel.none if patient.blank?

        validate_column!(widget_options.patient_id_column)

        rel.where(widget_options.patient_id_column => patient.id)
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

      def column_definition_for(attr)
        view_metadata.columns.detect { |col| col.code == attr } ||
          Renalware::System::ColumnDefinition.new(code: attr, hidden: false)
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
