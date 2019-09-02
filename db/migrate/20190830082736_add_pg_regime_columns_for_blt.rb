class AddPgRegimeColumnsForBlt < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :pd_regimes, :exchanges_done_by, :string
      add_column :pd_regimes, :exchanges_done_by_if_other, :string
      add_column :pd_regimes, :exchanges_done_by_notes, :text
    end
  end
end
