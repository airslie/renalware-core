class CreateReportingHDBloodPressuresAudit < ActiveRecord::Migration[5.0]
  def change
    create_view :reporting_hd_blood_pressures_audit, materialized: true
    add_index :reporting_hd_blood_pressures_audit,
              :hospital_unit_name,
              unique: true
  end
end
