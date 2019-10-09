class AddValidationRegexToPatientSurveyQuestions < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :survey_questions, :validation_regex, :text
    end
  end
end
