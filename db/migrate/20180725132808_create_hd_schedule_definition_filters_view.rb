class CreateHDScheduleDefinitionFiltersView < ActiveRecord::Migration[5.1]
  def change
    create_view :hd_schedule_definition_filters
  end
end
