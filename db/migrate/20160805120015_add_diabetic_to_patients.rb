class AddDiabeticToPatients < ActiveRecord::Migration[4.2]
  def change
    add_column :patients, :diabetic, :boolean, null: false, default: false
  end
end
