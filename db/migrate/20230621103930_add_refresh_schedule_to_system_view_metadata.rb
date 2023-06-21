class AddRefreshScheduleToSystemViewMetadata < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      add_column(
        :system_view_metadata,
        :refresh_schedule,
        :text,
        comment: "Cron or fugit schedule string for refreshing the view if it is materialized " \
                 "eg 'every day at 6am' or '0 * * * *' (every hour) or " \
                 "@hourly (turns into '0 * * * *') or '0 0 L * *' (last day of month at 00:00)"
      )
      add_column(
        :system_view_metadata,
        :refresh_concurrently,
        :boolean,
        default: false,
        null: false,
        comment: "where refresh_schedule is set, if refresh_concurrently is true then provided " \
                 "the materialised view has a unique index, the data will be reloaded without " \
                 "locking the table for selects - which is clearly advantageous"
      )
    end
  end
end
