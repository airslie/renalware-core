class CreateHDScheduleDefinitionFiltersView < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      create_view :hd_schedule_definition_filters
    end
  end
end
