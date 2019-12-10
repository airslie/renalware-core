class AddPatientQuestionTextToSurveyResponses < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :survey_responses, :patient_question_text, :text
    end
  end
end
