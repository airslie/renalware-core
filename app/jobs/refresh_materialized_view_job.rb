#
# Refresh a materialized view asynchronously via activejob.
# If no view_name supplied, refresh all materialized views
#
class RefreshMaterializedViewJob < ApplicationJob
  queue_with_priority 6

  def perform(view_name:, concurrently: false)
    conn = ActiveRecord::Base.connection
    if view_name.present?
      Rails.logger.info("Refreshing materialized view #{view_name}...")
      refresh_view(conn, view_name, concurrently)
    else
      Rails.logger.info("Refreshing all materialized views...")
      conn.execute("SELECT refresh_all_matierialized_views();")
    end
  end

  private

  def refresh_view(conn, view_name, concurrently)
    quoted_view_name = conn.quote_table_name(view_name)
    if concurrently == true
      conn.execute("REFRESH MATERIALIZED VIEW CONCURRENTLY #{quoted_view_name};")
    else
      conn.execute("REFRESH MATERIALIZED VIEW #{quoted_view_name};")
    end
  end
end
