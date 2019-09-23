class AddTelephoneToRenalConsultants < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :renal_consultants, :telephone, :string
    end
  end
end
