# frozen_string_literal: true

require_relative "../../seeds_helper"

module Renalware
  extend SeedsHelper

  log "Adding Clinica Visit Locations" do
    Clinics::VisitLocation.create(name: "In clinic", default_location: true)
    Clinics::VisitLocation.create(name: "By telephone")
    Clinics::VisitLocation.create(name: "Over Teams")
    Clinics::VisitLocation.create(name: "Other")
  end
end
