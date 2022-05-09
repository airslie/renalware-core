class AddMissingIndexes1 < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    within_renalware_schema do
      add_index :death_causes, :code, unique: true, algorithm: :concurrently
      add_index(
        :survey_questions,
        [:survey_id, :code],
        unique: true,
        algorithm: :concurrently,
        where: "deleted_at is null"
      )
      add_index :renal_prd_descriptions, :code, unique: true, algorithm: :concurrently
      remove_index :system_countries, :name
      add_index :system_countries, :name, unique: true, algorithm: :concurrently
      add_index(
        :problem_comorbidity_descriptions,
        :name,
        unique: true,
        algorithm: :concurrently,
        where: "deleted_at is null"
      )
    end
  end
end
