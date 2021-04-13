class AddReadCodeToDrugs < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :drugs, :read_code, :string, index: true
    end
  end
end
