module Renalware
  log "Adding Letter Descriptions"

  CSV.foreach(File.join(File.dirname(__FILE__),"letter_descriptions.csv"), headers: true) do |row|
    Letters::Description.find_or_create_by(text: row["text"])
  end
end
