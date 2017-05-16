class AddRenalregRpvToPatients < ActiveRecord::Migration[5.0]
  def change
    add_column :patients, :send_to_renalreg, :boolean, default: false, null: false, index: true
    add_column :patients, :send_to_rpv, :boolean, default: false, null: false, index: true
    add_column :patients, :renalreg_decision_on, :date
    add_column :patients, :rpv_decision_on, :date
    add_column :patients, :renalreg_recorded_by, :string
    add_column :patients, :rpv_recorded_by, :string
  end
end
