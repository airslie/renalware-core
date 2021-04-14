class AddHDStationIdToHDSessions < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_reference(
        :hd_sessions,
        :hd_station,
        foreign_key: true,
        index: false,
        null: true,
        comment: "The HD Station (eg 'Bay 1 Bed 2') where the patient was dialysed"
      )
    end
  end
end
