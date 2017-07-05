module Renalware
  log "Adding Renal Reg Cause of Death codes" do

    file_path = File.join(File.dirname(__FILE__), "death_causes.csv")

    CSV.foreach(file_path, headers: true) do |row|
      Deaths::Cause.find_or_create_by!(code: row["code"]) do |code|
        code.description = row["description"]
      end
    end
  end
end
