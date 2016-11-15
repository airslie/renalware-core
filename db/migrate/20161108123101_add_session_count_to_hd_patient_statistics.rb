class AddSessionCountToHDPatientStatistics < ActiveRecord::Migration
  def change
    add_column :hd_patient_statistics, :session_count, :integer, default: 0, null: false
  end
end
