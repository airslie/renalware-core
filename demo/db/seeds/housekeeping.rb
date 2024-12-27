# frozen_string_literal: true

Rails.benchmark "Refreshing all materialized views" do
  ActiveRecord::Base.connection.execute("SELECT refresh_all_matierialized_views();")
end
