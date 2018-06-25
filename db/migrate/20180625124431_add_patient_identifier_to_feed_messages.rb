class AddPatientIdentifierToFeedMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :feed_messages, :patient_identifer, :string, index: true
  end
end
