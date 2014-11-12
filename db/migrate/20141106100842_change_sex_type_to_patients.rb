class ChangeSexTypeToPatients < ActiveRecord::Migration
  def up
    change_column :patients, :sex, :integer, default: 9
  end

  def down
    change_column :patients, :sex, :string
  end
end
