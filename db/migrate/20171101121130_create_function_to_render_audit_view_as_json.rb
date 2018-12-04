class CreateFunctionToRenderAuditViewAsJson < ActiveRecord::Migration[5.1]
  def up
    within_renalware_schema do
      load_function("audit_view_as_json_v01.sql")
    end
  end

  def down
    within_renalware_schema do
      connection.execute("DROP FUNCTION IF EXISTS audit_view_as_json(text);")
    end
  end
end
