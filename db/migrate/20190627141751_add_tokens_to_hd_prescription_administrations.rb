class AddTokensToHDPrescriptionAdministrations < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      # add_column :hd_prescription_administrations, :administrator_authorisation_token, :string
      # add_column :hd_prescription_administrations, :witness_authorisation_token, :string
      add_column(
        :hd_prescription_administrations,
        :administrator_authorised,
        :boolean,
        default: false,
        null: false
      )
      add_column(
        :hd_prescription_administrations,
        :witness_authorised,
        :boolean,
        default: false,
        null: false
      )
    end
  end
end
