class RemoveAccessProcedureConstraints < ActiveRecord::Migration[5.0]
  def change
    change_column_null :access_procedures, :site_id, true
    change_column_null :access_procedures, :side, true
  end
end
