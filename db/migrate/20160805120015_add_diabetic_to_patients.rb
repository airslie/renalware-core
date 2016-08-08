class AddDiabeticToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :diabetic, :boolean, null: false, default: false
  end
end
