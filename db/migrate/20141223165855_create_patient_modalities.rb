class CreatePatientModalities < ActiveRecord::Migration
  def change
    create_table :patient_modalities do |t|

      t.timestamps
    end
  end
end
