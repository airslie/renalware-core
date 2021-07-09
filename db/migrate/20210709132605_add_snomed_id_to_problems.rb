class AddSnomedIdToProblems < ActiveRecord::Migration[6.0]
  def change
    add_column :problem_problems, :snomed_id, :string
  end
end
