class CreateActivityReport < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema(suffix: :heroic) do
      create_view :report_activity
    end
  end
end
