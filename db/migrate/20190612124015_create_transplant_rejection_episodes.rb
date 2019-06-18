class CreateTransplantRejectionEpisodes < ActiveRecord::Migration[5.2]
  def change
    create_table :transplant_rejection_episodes do |t|
      t.date :recorded_on, null: false
      t.text :notes
      t.references :followup,
                   foreign_key: { to_table: :transplant_recipient_followups },
                   null: false,
                   index: true
      t.references :updated_by, foreign_key: { to_table: :users }, index: true, null: false
      t.references :created_by, foreign_key: { to_table: :users }, index: true, null: false
      t.timestamps null: false
    end
  end
end
