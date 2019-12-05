class UpdateSurveyViews < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      update_view(
        :survey_pos_s_pivoted_responses,
        version: 2,
        revert_to_version: 1,
        materialized: false
      )
    end
  end
end
