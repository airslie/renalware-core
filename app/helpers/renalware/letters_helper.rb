module Renalware
  module LettersHelper
    def recipient_sources(letter)
      collection = []
      address_fields = %i(street_1 street_2 city county postcode country)
      if doctor = DoctorPresenter.new(letter.patient.doctor)
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


