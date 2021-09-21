class CreateFeedPracticeGps < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_table :feed_practice_gps do |t|
        t.text :gp_code, null: false
        t.text :practice_code, null: false
        t.date :joined_on
        t.date :left_on
        t.integer :primary_care_physician_id
        t.integer :practice_id
      end
    end
  end
end
