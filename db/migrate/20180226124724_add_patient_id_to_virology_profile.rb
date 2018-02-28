class AddPatientIdToVirologyProfile < ActiveRecord::Migration[5.1]
  def change
    add_reference :virology_profiles,
                  :patient,
                  foreign_key: true,
                  index: { unique: true },
                  null: false
  end
end
