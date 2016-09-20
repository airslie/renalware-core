module Renalware
  log "Adding Failure Causes"

  file_path = File.join(File.dirname(__FILE__), "failure_cause_descriptions.csv")

  CSV.foreach(file_path, headers: true) do |row|
    group = Transplants::FailureCauseDescriptionGroup.find_or_create_by!(name: row["group"])
    Transplants::FailureCauseDescription.find_or_create_by!(code: row["code"]) do |cause|
      cause.group = group
      cause.name = row["name"]
    end
  end
end
