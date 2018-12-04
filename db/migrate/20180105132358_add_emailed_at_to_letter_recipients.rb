class AddEmailedAtToLetterRecipients < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      add_column :letter_recipients, :emailed_at, :datetime, index: true
      add_column :letter_recipients, :printed_at, :datetime, index: true
    end
  end
end
