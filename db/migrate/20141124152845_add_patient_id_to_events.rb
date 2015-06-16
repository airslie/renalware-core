class AddPatientIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :patient_id, :integer
  end
end
