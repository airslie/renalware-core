module Renalware
  module LettersHelper
    def recipient_sources(letter)
      collection = []

      if letter.patient.doctor.present?
        doctor = DoctorPresenter.new(letter.patient.doctor)
        label = "Doctor <address>#{doctor.full_name}, #{doctor.address_line}</address>".html_safe
        collection << [label, "Renalware::Doctor"]
      end

      patient = PatientPresenter.new(letter.patient)
      label = "Patient <address>#{patient.full_name}, #{patient.address_line}</address>".html_safe
      collection << [label, "Renalware::Patient"]

      collection << ["Postal Address Below", ""]
    end
  end
end


