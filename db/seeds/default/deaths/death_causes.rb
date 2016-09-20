module Renalware
  log "Adding Renal Reg Cause of Death codes"

  file_path = File.join(File.dirname(__FILE__), "death_causes.csv")

  CSV.foreach(file_path, headers: true) do |row|
    Deaths::EDTACode.find_or_create_by!(code: row['code']) do |code|
      code.death_cause = row['cause']
    end
  end
end
