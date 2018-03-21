# frozen_string_literal: true

module Renalware
  log "Adding Access Types" do

    file_path = File.join(File.dirname(__FILE__), "access_types.csv")

    CSV.foreach(file_path, headers: true) do |row|
      Accesses::Type.find_or_create_by!(code: row["code"]) do |type|
        type.name = row["name"]
        type.abbreviation = row["abbreviation"]
      end
    end
  end
end
