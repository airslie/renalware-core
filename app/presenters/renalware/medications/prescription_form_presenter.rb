# frozen_string_literal: true

module Renalware
  module Medications
    class PrescriptionFormPresenter
      attr_reader :selected_drug_id, :selected_form_id, :prescription, :selected_trade_family_id

      SEPARATOR = ":"

      OTHER_FREQUENCY = OpenStruct.new(name: Drugs::Frequency::OTHER_NAME,
                                       title: Drugs::Frequency::OTHER_TITLE)

      def initialize(prescription:, selected_drug_id:, selected_form_id: nil,
                     selected_trade_family_id: nil)
        @prescription = prescription
        @selected_drug_id = selected_drug_id
        @selected_trade_family_id = selected_trade_family_id

        if selected_drug_id && selected_form_id.present? &&
           vmps.any? { |c| c.form_id == selected_form_id.to_i }
          @selected_form_id = selected_form_id.to_i
        elsif forms.size == 1
          @selected_form_id = forms.first.id
        end

        clean_prescription_from_invalid_values
      end

      def clean_prescription_from_invalid_values
        unless medication_routes.map(&:id).include?(prescription.medication_route_id)
          prescription.medication_route_id = nil
        end

        unless forms.map(&:id).include?(prescription.form_id)
          prescription.form_id = nil
        end

        unless unit_of_measures.map(&:id).include?(prescription.unit_of_measure_id)
          prescription.unit_of_measure_id = nil
        end
      end

      def medication_routes
        return [] if selected_drug_id.blank?

        @medication_routes ||= begin
          selection = if selected_form_id
                        vmps.select { |c| c.form_id == selected_form_id }
                      else
                        vmps
                      end

          MedicationRoute.where(id: selection.map(&:route_id))
            .presence || MedicationRoute.all
        end
      end

      def forms
        return [] if selected_drug_id.blank?

        @forms ||= Drugs::Form.where(id: vmps.map(&:form_id)).presence ||
                   Drugs::Form.all
      end

      def drugs_collection
        if prescription.drug&.inactive?
          [[prescription.drug.name,
            prescription.drug.id]]
        elsif exit_site_or_peritonities?
          antibiotics_drug_list
        else
          drugs_and_trade_families_list
        end
      end

      def unit_of_measures
        return [] if selected_drug_id.blank?

        @unit_of_measures ||= begin
          selection = if selected_form_id
                        vmps.select { |c| c.form_id == selected_form_id }
                      else
                        vmps
                      end

          Drugs::UnitOfMeasure.where(id: selection.map(&:unit_of_measure_id)).presence ||
            Drugs::UnitOfMeasure.all
        end
      end

      def frequencies
        Drugs::Frequency.all.to_a + [OTHER_FREQUENCY]
      end

      private

      def antibiotics_drug_list
        Drugs::Drug.for(:antibiotic).order(:name).pluck(:name, :id)
      end

      def exit_site_or_peritonities?
        prescription.treatable.is_a?(Renalware::PD::PeritonitisEpisode) ||
          prescription.treatable.is_a?(Renalware::PD::ExitSiteInfection)
      end

      def vmps
        @vmps ||= begin
          scope = Drugs::VMPClassification.where(drug_id: selected_drug_id, inactive: false)

          if selected_trade_family_id
            scope = scope.where("? = ANY(trade_family_ids)", selected_trade_family_id)
          end

          scope
        end
      end

      def drugs_and_trade_families_list
        drugs = Drugs::Drug.active.select(
          "name",
          "id",
          "NULL as trade_family_id",
          "NULL as trade_family_name"
        ).arel

        drugs_and_trade_families = Drugs::Drug.active.joins(:enabled_trade_families).select(
          "drugs.name",
          "drugs.id",
          "drug_trade_families.id as trade_family_id",
          "drug_trade_families.name as trade_family_name"
        ).arel

        union = Arel::Nodes::Union.new(drugs, drugs_and_trade_families)

        Drugs::Drug.from(Drugs::Drug.arel_table.create_table_alias(union, :drugs))
          .with_deleted
          .order(:name, "trade_family_name NULLS FIRST")
          .pluck(
            Arel.sql(
              "CASE when trade_family_name is null " \
              "THEN name ELSE (name || ' (' || trade_family_name || ')') " \
              "END"
            ),
            Arel.sql(
              "CASE when trade_family_name is null " \
              "THEN id::text ELSE (id || '#{SEPARATOR}' || trade_family_id) " \
              "END"
            )
          )
      end
    end
  end
end
