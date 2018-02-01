class CreateFunctionToRenderAuditViewAsJson < ActiveRecord::Migration[5.1]
  def up
    load_function("audit_view_as_json_v01.sql")
  end

  def down
    connection.execute(
      "DROP FUNCTION IF EXISTS audit_view_as_json(text);"
    )
  end
end
