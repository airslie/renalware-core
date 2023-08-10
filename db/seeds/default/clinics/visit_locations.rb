# frozen_string_literal: true

require_relative "../../seeds_helper"

module Renalware
  extend SeedsHelper

  log "Adding Clinic Visit Locations" do
    user = Renalware::User.first
    Clinics::VisitLocation.create(name: "In clinic", default_location: true, by: user)
    Clinics::VisitLocation.create(name: "By telephone", by: user)
    Clinics::VisitLocation.create(name: "Over Teams", by: user)
    Clinics::VisitLocation.create(name: "Other", by: user)
  end
end
