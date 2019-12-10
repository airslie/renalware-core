class UpdateSurveyViewsToAllowFreeText < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      update_view(
        :survey_pos_s_pivoted_responses,
        version: 3,
        revert_to_version: 2,
        materialized: false
      )
    end
  end
end
