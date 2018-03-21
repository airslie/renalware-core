# frozen_string_literal: true

log "Refreshing all materialized views" do
  ActiveRecord::Base.connection.execute("SELECT refresh_all_matierialized_views();")
end
