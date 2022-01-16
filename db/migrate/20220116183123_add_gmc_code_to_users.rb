class AddGMCCodeToUsers < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :users, :gmc_code, :string
    end
  end
end
