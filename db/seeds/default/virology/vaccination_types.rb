# frozen_string_literal: true

module Renalware
  module Virology
    log "Adding virology vaccination types" do
      {
        hbv1: "HBV Vaccination 1",
        hbv2: "HBV Vaccination 2",
        hbv3: "HBV Vaccination 3",
        hbv4: "HBV Vaccination 4",
        hbv_booster: "HBV Booster",
        influenza: "Influenza",
        pneumococcus: "Pneumococcus",
        covid19_1: "COVID-19 1",
        covid19_2: "COVID-19 2",
        patient_refused: "Patient Refused",
        patient_refused_covid19: "Patient refused Covid-19 vaccine",
        patient_refused_covid19_pfizer: "Patient refused Covid-19 vaccine Pfizer",
        patient_refused_covid19_astrazenica: "Patient refused Covid-19 vaccine Astra Zeneca"
      }.each do |code, name|
        VaccinationType.find_or_create_by!(code: code, name: name)
      end
    end
  end
end
