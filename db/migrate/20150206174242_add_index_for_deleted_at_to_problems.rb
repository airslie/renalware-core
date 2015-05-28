class AddIndexForDeletedAtToProblems < ActiveRecord::Migration
  def change
    add_index :problems, :deleted_at
  end
end
