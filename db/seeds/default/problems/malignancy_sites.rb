# frozen_string_literal: true

module Renalware
  log "Adding malignancy sites" do
    file_path = File.join(File.dirname(__FILE__), "malignancy_sites.csv")
    malignancy_sites = CSV.foreach(file_path, headers: true).map do |row|
      row.to_h.symbolize_keys
    end
    Problems::MalignancySite.upsert_all(malignancy_sites, unique_by: :description)
  end
end
