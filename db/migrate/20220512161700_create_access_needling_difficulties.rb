class CreateAccessNeedlingDifficulties < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      create_enum :access_needling_difficulty_types, %w(easy moderate hard)

      create_table(
        :access_needling_difficulties,
        comment: "Stores 'Ease of Needling Vascular Access' aka MAGIC score - see enum"
      ) do |t|
        t.references :patient, null: false, foreign_key: true
        t.enum :difficulty, enum_name: :access_needling_difficulty_types, null: false
        t.references :created_by, index: true, null: false, foreign_key: { to_table: :users }
        t.references :updated_by, index: true, null: false, foreign_key: { to_table: :users }
        t.timestamps null: false
        t.index [:patient_id, :created_at]
      end
    end
  end
end
