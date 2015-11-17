class CreateTransplantsDonations < ActiveRecord::Migration
  def change
    create_table :transplants_donations do |t|
      t.belongs_to :patient, index: true, foreign_key: true

      t.string :state
      t.string :relationship_with_recipient
      t.string :blood_group_compatibility
      t.string :mismatch_grade
      t.string :paired_pooled_donation
      t.date :volunteered_on
      t.date :first_seen_on
      t.date :workup_completed_on
      t.date :donated_on
      t.text :notes

      t.timestamps null: false
    end
  end
end
