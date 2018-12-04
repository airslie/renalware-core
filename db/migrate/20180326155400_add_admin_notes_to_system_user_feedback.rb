class AddAdminNotesToSystemUserFeedback < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      add_column :system_user_feedback, :admin_notes, :text
      add_column :system_user_feedback, :acknowledged, :boolean
    end
  end
end
