class CreateTransplantRejectionTreatments < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      # The treatment given for an episode
      create_table :transplant_rejection_treatments do |t|
        t.text :name, null: false, index: :unique
        t.integer :position, index: true, null: false, default: 0
        t.timestamps null: false
      end

      add_reference(
        :transplant_rejection_episodes,
        :treatment,
        foreign_key: { to_table: :transplant_rejection_treatments },
        index: true
      )
    end
  end
end
