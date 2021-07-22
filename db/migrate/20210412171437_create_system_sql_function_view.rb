class CreateSystemSqlFunctionView < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_view :system_sql_functions
    end
  end
end
