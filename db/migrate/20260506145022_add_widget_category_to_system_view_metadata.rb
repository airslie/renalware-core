class AddWidgetCategoryToSystemViewMetadata < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_enum_value :system_view_category, "widget", if_not_exists: true

    unless column_exists?(:system_view_metadata, :widget_options)
      add_column(
        :system_view_metadata,
        :widget_options,
        :jsonb,
        default: {},
        null: false
      )
    end
  end
end
