class AddLabelAbbrvToSurveyQuestions < ActiveRecord::Migration[5.2]
  within_renalware_schema do
    def change
      add_column(
        :survey_questions,
        :label_abbrv,
        :string,
        comment: "If populated, used instead of label when displaying the table, to save space"
      )
    end
  end
end
