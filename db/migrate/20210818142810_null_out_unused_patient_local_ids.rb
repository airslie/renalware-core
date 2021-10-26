class NullOutUnusedPatientLocalIds < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      %i(
        local_patient_id
        local_patient_id_2
        local_patient_id_3
        local_patient_id_4
        local_patient_id_5
      ).each do |col|
        execute("UPDATE patients set #{col} = null where #{col} = '';")
      end
    end
  end
end
