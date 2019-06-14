class AddFieldsToTransplantRecipientWorkup < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :transplant_recipient_followups, :graft_function_onset, :string
      add_column :transplant_recipient_followups, :last_post_transplant_dialysis_on, :date
      add_column :transplant_recipient_followups, :return_to_regular_dialysis_on, :date
    end
  end
end
