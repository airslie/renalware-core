class CreateHDPreferenceSets < ActiveRecord::Migration
  def change
    create_table :renalware_hd_preference_sets do |t|
      t.belongs_to :hospital_unit, index: true, foreign_key: true
      t.string :schedule
      t.string :other_schedule
      t.date :entered_on
      t.text :notes

      t.timestamps null: false
    end
  end
end
