class CreateTransplantsDonations < ActiveRecord::Migration
  def change
    create_table :transplants_donations do |t|
      t.belongs_to :patient, index: true, foreign_key: true

      t.string :status
      t.text :notes

      t.timestamps null: false
    end
  end
end
