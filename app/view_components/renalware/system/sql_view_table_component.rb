module Renalware
  module System
    class SqlViewTableComponent < ApplicationComponent
      TECHNICAL_COLUMNS = %w(id secure_id document).freeze
      PATIENT_LINK_COLUMNS = %w(patient patient_name).freeze

      rattr_initialize [
        :view_metadata!,
        :rows!,
        pagination: nil,
        row_action_label: nil,
        row_path_proc: nil,
        sort: nil,
        table_id: nil
      ]

      def columns
        @columns ||= attribute_names.filter_map do |attr|
          column_definition_for(attr).then { |column| column unless column.hidden }
        end
      end

      def table_classes_for(column)
        classes = inferred_width_classes_for(column.code)
        classes << "col-width-#{column.width}" if classes.empty? && column.width.present?
        classes.join(" ")
      end

      def cell_classes_for(column)
        return unless column.truncate && column.width.present?

        "col-width-#{column.width}-with-ellipsis"
      end

      def cell_title_for(column, value)
        value if column.truncate
      end

      def render_header_for(column)
        return column.title if sort.blank?

        helpers.sort_link(sort, column.code, column.title)
      end

      def render_cell_for(row, column)
        code = column.code
        if patient_link?(row, code)
          return helpers.patient_link(row, landing_page: view_metadata.patient_landing_page)
        end

        value = row.attributes[code]
        value = helpers.l(value) if value.respond_to?(:strftime)

        if [true, "Y"].include?(value)
          helpers.inline_checked_icon
        elsif [false, "N"].include?(value)
          helpers.inline_unchecked_icon
        else
          value
        end
      end

      def row_action?
        row_path_proc.present?
      end

      def pagination?
        pagination.present?
      end

      private

      def attribute_names
        @attribute_names ||= begin
          sql_attribute_names = rows.first.class.columns.map(&:name) - TECHNICAL_COLUMNS
          (view_metadata.columns.map(&:code) + sql_attribute_names).uniq
        end
      end

      def column_definition_for(attr)
        view_metadata.columns.detect { |col| col.code == attr } ||
          Renalware::System::ColumnDefinition.new(code: attr, hidden: false)
      end

      def inferred_width_classes_for(code)
        [].tap do |classes|
          classes << "col-width-date" if code.end_with?("_date", "_on")
          classes << "col-width-date-time" if code.end_with?("_at")
          classes << "col-width-nhs-no" if code == "nhs_number"
          classes << "col-width-tiny" if code.in?(%w(age sex))
          classes << "col-width-large" if code == "patient_name"
        end
      end

      def patient_link?(row, code)
        row["secure_id"].present? && PATIENT_LINK_COLUMNS.include?(code)
      end
    end
  end
end
