class RemoveColumnDrugsVmpid < ActiveRecord::Migration[6.0]
  def change
    safety_assured do
      remove_column :drugs, :vmpid, :integer
    end
  end
end
