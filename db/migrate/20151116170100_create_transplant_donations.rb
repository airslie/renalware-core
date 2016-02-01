class CreateTransplantDonations < ActiveRecord::Migration
  def change
    create_table :transplant_donations do |t|
      t.belongs_to :patient, index: true, foreign_key: true

      t.integer :recipient_id
      t.string :state, null: false
      t.string :relationship_with_recipient, null: false
      t.string :relationship_with_recipient_other
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

    add_index :transplant_donations, :recipient_id
  end
end
