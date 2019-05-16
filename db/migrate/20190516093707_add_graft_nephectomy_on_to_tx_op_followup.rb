class AddGraftNephectomyOnToTxOpFollowup < ActiveRecord::Migration[5.2]
  def change
    add_column :transplant_recipient_followups, :graft_nephrectomy_on, :date
  end
end
