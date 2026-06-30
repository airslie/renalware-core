module Renalware
  module Medications
    class AdministeredDosesQuery
      def self.count(prescription:, excluding_administration: nil)
        relation = administered_relation_for(prescription)
        return 0 if relation.nil?

        if excluding_administration&.id
          relation = relation.where.not(id: excluding_administration.id)
        end
        relation.count
      end

      def self.counts_for(prescriptions)
        prescriptions
          .group_by { |prescription| administration_model_for(prescription) }
          .each_with_object({}) do |(model, grouped_prescriptions), counts|
            next if model.nil?

            counts.merge!(counts_for_model(model, grouped_prescriptions))
          end
      end

      def self.administered_relation_for(prescription)
        model = administration_model_for(prescription)
        return if model.nil?

        model.where(prescription:, administered: true)
      end
      private_class_method :administered_relation_for

      def self.counts_for_model(model, prescriptions)
        prescription_ids = prescriptions.filter_map(&:id)
        return {} if prescription_ids.empty?

        model
          .where(prescription_id: prescription_ids, administered: true)
          .group(:prescription_id)
          .count
      end
      private_class_method :counts_for_model

      def self.administration_model_for(prescription)
        return OutpatientPrescriptionAdministration if prescription.give_as_outpatient?

        HD::PrescriptionAdministration if prescription.administer_on_hd?
      end
      private_class_method :administration_model_for
    end
  end
end
