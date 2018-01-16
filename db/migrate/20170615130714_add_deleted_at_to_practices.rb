class AddDeletedAtToPractices < ActiveRecord::Migration[5.0]
  def change
    add_column :patient_practices, :deleted_at, :datetime
    add_column :patient_practices, :telephone, :string
    add_index :patient_practices, :deleted_at
  end
end
