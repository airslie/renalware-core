class CreateFeedGps < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_table :feed_gps do |t|
        t.text :code, index: { unique: true }, null: false
        t.text :name, null: false
        t.text :telephone
        t.text :street_1
        t.text :street_2
        t.text :street_3
        t.text :town
        t.text :county
        t.text :postcode
        t.string :status
      end
    end
  end
end
