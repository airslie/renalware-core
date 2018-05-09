# frozen_string_literal: true

module Renalware
  log "Adding Renal Reg Cause of Death codes" do
    return if Deaths::Cause.count > 0

    file_path = File.join(File.dirname(__FILE__), "death_causes.csv")
    causes = []
    CSV.foreach(file_path, headers: true) do |row|
      causes << Deaths::Cause.new(code: row["code"], description: row["description"])
    end
    Deaths::Cause.import! causes
  end
end
