class AddDeathDateToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :death_date, :datetime
  end
end
