class AddHomeMachineSerialNumberToHDProfile < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      add_column(
        :hd_profiles,
        :home_machine_identifier,
        :string,
        comment: "eg serial number of Baxter Home AK98 dialyser with which we sync via HDCloud API"
      )
      safety_assured do
        add_index(
          :hd_profiles,
          :home_machine_identifier,
          unique: true,
          where: "deactivated_at IS NULL and coalesce(home_machine_identifier, '') != ''",
          comment: "Must be unique among active HD Profiles, ignoring blanks"
        )
      end
    end
  end
end
