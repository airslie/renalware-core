class AddSnomedDescriptionToProblem < ActiveRecord::Migration
  def change
    add_column :problems, :snomed_description, :string
  end
end
