class AddNotesToPatientWorries < ActiveRecord::Migration[5.1]
  def change
    add_column :patient_worries, :notes, :text
  end
end
