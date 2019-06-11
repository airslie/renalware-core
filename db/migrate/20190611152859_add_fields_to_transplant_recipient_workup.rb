class AddFieldsToTransplantRecipientWorkup < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :transplant_recipient_followups, :graft_function_onset, :string
    end
  end
end
