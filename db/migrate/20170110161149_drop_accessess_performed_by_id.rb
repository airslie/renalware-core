class DropAccessessPerformedById < ActiveRecord::Migration[5.0]
  def up
    remove_foreign_key :access_procedures, column: :performed_by_id
    remove_column :access_procedures, :performed_by_id, :integer
  end

  def down
    add_column :access_procedures, :performed_by_id, :integer
    add_foreign_key :access_procedures, :users, column: :performed_by_id
  end
end
