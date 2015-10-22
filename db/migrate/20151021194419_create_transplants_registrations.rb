class CreateTransplantsRegistrations < ActiveRecord::Migration
  def change
    create_table :transplants_registrations do |t|
      t.belongs_to :patient, index: true, foreign_key: true
      t.jsonb :document

      t.timestamps null: false
    end

    add_index :transplants_registrations, :document, using: :gin
  end
end
