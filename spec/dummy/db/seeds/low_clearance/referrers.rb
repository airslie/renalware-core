# frozen_string_literal: true

module Renalware
  log "Adding Advanced Kidney Care Referrers" do
    file_path = File.join(File.dirname(__FILE__), "referrers.csv")

    CSV.foreach(file_path, headers: true) do |row|
      LowClearance::Referrer.find_or_create_by!(name: row["name"])
    end
  end
end
