class MakeLocalHospIdsCaseInsensitive < ActiveRecord::Migration[5.1]
  def change
    # Use the citext type on local_hospital_ids so we can use
    # case-insensitive queries
    enable_extension "citext"

    columns = %i(
      local_patient_id
      local_patient_id_2
      local_patient_id_3
      local_patient_id_4
      local_patient_id_5
    )

    columns.each{ |column| remove_index(:patients, column) }
    columns.each{ |column| change_column(:patients, column, :citext) }
    columns.each{ |column| add_index(:patients, column) }
  end
end
