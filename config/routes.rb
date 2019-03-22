# frozen_string_literal: true

Renalware::Engine.routes.draw do
  root to: "dashboard/dashboards#show"
  draw :accesses
  draw :admin
  draw :admissions
  draw :api
  draw :clinical
  draw :clinics
  draw :directory
  draw :drugs
  draw :events
  draw :hd
  draw :hospitals
  draw :letters
  draw :low_clearance
  draw :medications
  draw :messaging
  draw :modalities
  draw :pathology
  draw :patients
  draw :pd
  draw :renal
  draw :reporting
  draw :research
  draw :snippets
  draw :system
  draw :transplants
  draw :virology

  # Last
  draw :fallbacks
end
