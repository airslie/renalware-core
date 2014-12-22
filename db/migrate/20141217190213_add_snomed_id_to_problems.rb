class AddSnomedIdToProblems < ActiveRecord::Migration
  def change
    add_column :problems, :snomed_id, :string
  end
end
