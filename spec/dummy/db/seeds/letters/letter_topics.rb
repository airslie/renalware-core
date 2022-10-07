# frozen_string_literal: true

module Renalware
  log "Adding Letter Topics" do
    CSV.foreach(File.join(File.dirname(__FILE__), "letter_descriptions.csv"), headers: true) do |row|
      Letters::Topic.find_or_create_by(text: row["text"])
    end
  end
end
