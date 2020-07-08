class AddPrescriberToUsers < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      add_column(
        :users,
        :prescriber,
        :boolean,
        null: false,
        default: false,
        comment: "A user can only add or terminate a prescription if this is set to true"
      )
    end
  end
end
