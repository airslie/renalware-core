class AddIndexForDeletedAtToMedications < ActiveRecord::Migration
  def change
    add_index :medications, :terminated_at
  end
end
