class CreateRenalwareTransplantRecipientWorkups < ActiveRecord::Migration
  def change
    create_table :transplant_recipient_workups do |t|
      t.belongs_to :patient, index: true, foreign_key: true
      t.jsonb :document

      t.timestamps null: false
    end

    add_index :transplant_recipient_workups, :document, using: :gin
  end
end
