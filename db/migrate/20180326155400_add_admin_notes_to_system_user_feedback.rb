class AddAdminNotesToSystemUserFeedback < ActiveRecord::Migration[5.1]
  def change
    add_column :system_user_feedback, :admin_notes, :text
    add_column :system_user_feedback, :acknowledged, :boolean
  end
end
