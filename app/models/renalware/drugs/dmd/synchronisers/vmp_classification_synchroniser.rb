# frozen_string_literal: true

module Renalware
  module Drugs
    module DMD::Synchronisers
      # Build a many-to-many table between a Drug and From, Unit of Measure and Route
      #
      class VMPClassificationSynchroniser
        def call # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
          drug_code_to_id_map = Drugs::DrugCodeToIdMap.new
          forms = Form.all.index_by(&:code)
          units_of_measure = UnitOfMeasure.all.index_by(&:code)
          routes = Medications::RoutesIndexedByCodeMap.new
          trade_family_code_to_id = TradeFamily.pluck(:code, :id).to_h

          # Create a mapping between vmp code and trade family codes:
          # 'VMP_CODE' => ['TRADE_FAMILY_CODE_1', 'TRADE_FAMILY_CODE_1', ..]
          vmp_code_to_trade_family_codes = DMD::ActualMedicalProduct.where.not(trade_family_code: nil)
            .pluck(
              :virtual_medical_product_code,
              :trade_family_code
            ).each_with_object({}) do |(vmp_code, trade_family_code), acc|
            acc[vmp_code] ||= Set.new
            acc[vmp_code] << trade_family_code
          end

          DMD::VirtualMedicalProduct.find_in_batches(batch_size: 500) do |batch|
            upserts = []

            batch.each do |vmp|
              form = forms[vmp.form_code]
              unit_of_measure = units_of_measure[vmp.unit_of_measure_code]
              drug_id = drug_code_to_id_map[vmp.virtual_therapeutic_moiety_code]
              route = routes[vmp.route_code]
              trade_family_codes = (vmp_code_to_trade_family_codes[vmp.code] || [])
              trade_family_ids = trade_family_codes.map { |trade_family_code|
                trade_family_code_to_id[trade_family_code]
              }

              next if drug_id.nil?

              upserts.push(
                {
                  code: vmp.code,
                  drug_id: drug_id,
                  form_id: form&.id,
                  unit_of_measure_id: unit_of_measure&.id,
                  route_id: route&.id,
                  trade_family_ids: trade_family_ids,
                  inactive: vmp.inactive
                }
              )
            end

            next if upserts.none?

            VMPClassification.upsert_all(
              upserts,
              unique_by: :index_drug_vmp_classifications_on_code
            )
          end
        end
      end
    end
  end
end
