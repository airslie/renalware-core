require_dependency "renalware"
require "subscription_registry"

module Renalware
  module Letters
    module_function

    def self.table_name_prefix
      "letter_"
    end

    def cast_patient(patient)
      ActiveType.cast(patient, ::Renalware::Letters::Patient)
    end

    def cast_doctor(doctor)
      ActiveType.cast(doctor, ::Renalware::Letters::Doctor)
    end

    def configure
      SubscriptionRegistry.instance.register(Patients::UpdatePatient, UpdatePatientListener)
      SubscriptionRegistry.instance.register(Doctors::UpdateDoctor, UpdateDoctorListener)
    end
  end
end