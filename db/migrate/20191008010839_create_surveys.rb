class CreateSurveys < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_table :survey_surveys do |t|
        t.string :name, null: false
        t.string :code, null: false
        t.string :description
        t.datetime :deleted_at, index: true
        t.timestamps null: false
      end

      # name must be unique among non-deleted surveys
      add_index(
        :survey_surveys,
        :name,
        unique: true,
        where: "deleted_at is NULL"
      )

      # code must be unique among non-deleted surveys
      add_index(
        :survey_surveys,
        :code,
        unique: true,
        where: "deleted_at is NULL"
      )

      create_table :survey_questions do |t|
        t.references(
          :survey,
          foreign_key: { to_table: :survey_surveys },
          index: true,
          null: false
        )
        t.string :code, null: false
        t.string :label
        t.integer :position, null: false, default: 0, index: true
        t.datetime :deleted_at, index: true
        t.timestamps null: false
      end

      # Prevent a unique index on code within any survey, but exclusing deleted questions.
      add_index(
        :survey_questions,
        [:code, :survey_id],
        unique: true,
        where: "deleted_at is NULL"
      )

      create_table :survey_responses do |t|
        t.date :answered_on, null: false, index: true
        t.references(:patient, null: false)
        t.references(
          :question,
          foreign_key: { to_table: :survey_questions },
          null: false
        )
        t.string :value
        t.string :reference # for future use - possibly to tie responses together?
        t.timestamps null: false
      end

      add_index(
        :survey_responses,
        [:answered_on, :patient_id, :question_id],
        name: :survey_responses_compound_index
      )
    end
  end
end
