class AddSessionCountToHDPatientStatistics < ActiveRecord::Migration[4.2]
  def change
    add_column :hd_patient_statistics, :session_count, :integer, default: 0, null: false
  end
end
