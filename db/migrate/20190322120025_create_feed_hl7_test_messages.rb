class CreateFeedHL7TestMessages < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_table :feed_hl7_test_messages do |t|
        t.string :name, null: false, index: true
        t.string :description
        t.text :body, null: false
        t.timestamps
      end
    end
  end
end
