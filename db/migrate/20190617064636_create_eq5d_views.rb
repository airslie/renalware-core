class CreateEQ5DViews < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_view :patient_eq5d_pivoted_responses
      create_view :patient_pos_s_pivoted_responses
    end
  end
end
