# frozen_string_literal: true

module Renalware
  log "Adding Demo Event Types" do
    file_path = File.join(File.dirname(__FILE__), "event_types.csv")

    category = Events::Category.first
    CSV.foreach(file_path, headers: true) do |row|
      event_type = Events::Type.find_or_create_by!(name: row["name"], category: category)
      # For some reason save_pdf_to_electronic_public_register is not available until we
      # reload the event_type. Started happening on 9 May 18.
      event_type.reload.update!(
        save_pdf_to_electronic_public_register: row["save_pdf_to_electronic_public_register"]
      )
    end
  end
end
