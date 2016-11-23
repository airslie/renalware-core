module Renalware
  log "Adding Event Types" do

    file_path = File.join(File.dirname(__FILE__), "event_types.csv")

    Events::Type.transaction do
      events = CSV.read(file_path, headers: false)
      columns = events[0]
      Events::Type.import! columns, events[1..-1], validate: true
    end
  end
end
