# frozen_string_literal: true

module Renalware
  log "Adding HD Providers" do
    HD::TransmissionLog.create!(
      direction: :in,
      format: :xml,
      payload: "<session>abc</session>"
    )
    HD::TransmissionLog.create!(
      direction: :out,
      format: :hl7,
      payload: "Example|HL7|Message"
    )
  end
end
