class AddUserToPDRegime < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      within_renalware_schema do
        change_table(:pd_regimes) do |t|
          t.references :created_by, index: true, foreign_key: { to_table: :users }
          t.references :updated_by, index: true, foreign_key: { to_table: :users }
        end
      end
    end
  end
end
