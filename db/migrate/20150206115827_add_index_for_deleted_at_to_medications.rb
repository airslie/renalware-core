class AddIndexForDeletedAtToMedications < ActiveRecord::Migration
  def change
    add_index :medications, :deleted_at
  end
end
