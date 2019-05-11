# frozen_string_literal: true

module Renalware
  module UKRDC
    log "Adding UKRDC modality codes" do
      file_path = File.join(File.dirname(__FILE__), "modality_codes.csv")

      CSV.foreach(file_path, headers: true) do |row|
        ModalityCode.find_or_create_by!(
          qbl_code: row["qbl_code"],
          txt_code: row["txt_code"],
          description: row["description"]
        )
      end
    end
  end
end
