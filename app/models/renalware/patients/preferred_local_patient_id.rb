module Renalware
  class PreferredLocalPatientId
    attr_reader :name, :value
    alias_method :to_sym, :name
    alias_method :to_s, :value
    delegate :present?, to: :name

    def initialize(patient)
      @name = local_ids_in_use(patient).first
      return unless @name
      @value = patient.send(@name)
    end

    private

    def local_ids_in_use(patient)
      local_patient_id_attribute_names_in_order_of_preference.reject do |att|
        patient.public_send(att).empty?
      end
    end

    def local_patient_id_attribute_names_in_order_of_preference
      %i(local_patient_id
         local_patient_id_2
         local_patient_id_3
         local_patient_id_4
         local_patient_id_5)
    end
  end
end
