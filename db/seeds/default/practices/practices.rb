# frozen_string_literal: true

module Renalware
  log "Adding NHS Practices\n" do
    sample_status = "SAMPLE ONLY"
    uk = System::Country.find_by!(alpha2: "GB")
    Patients::Practice.transaction do
      # NOTE: use '_sample' file for demo/devel
      CSV.foreach(File.join(File.dirname(__FILE__), "nhs_practices_sample.csv"), headers: true) do |row|
        practice = Patients::Practice.find_or_initialize_by(code: row["code"])
        practice.name = row["name"]
        if practice.address.blank?
          practice.build_address(
            organisation_name: row["name"],
            postcode: row["postcode"],
            street_1: row["street_1"],
            street_2: row["street_2"],
            town: row["town"],
            country_id: uk.id
          )
        end
        practice.save!
      end
    end

    log_count = Patients::Practice.count
    log "#{log_count} practices imported #{sample_status}", type: :sub
  end
end
