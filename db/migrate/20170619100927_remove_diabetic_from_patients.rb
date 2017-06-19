class RemoveDiabeticFromPatients < ActiveRecord::Migration[5.0]
  def change
    remove_column :patients, :diabetic, :boolean
  end
end
