class AllowIncompleteHeidiLaunchRecords < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      change_column_null :heidi_sessions, :heidi_session_id, true
      change_column_null :heidi_sessions, :heidi_patient_profile_id, true
    end
  end
end
