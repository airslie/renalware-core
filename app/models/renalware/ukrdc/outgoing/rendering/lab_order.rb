# frozen_string_literal: true

# rubocop:disable Metrics/AbcSize
module Renalware
  module UKRDC
    module Outgoing
      module Rendering
        class LabOrder < Rendering::Base
          pattr_initialize [:patient!, :request!]

          def xml
            lab_order_element
          end

          private

          def lab_order_element
            Ox::Element.new("LabOrder").tap do |lab_order|
              lab_order << create_node("PlacerId", request.placer_id)
              lab_order << order_category_element
              lab_order << create_node("SpecimenCollectedTime", request.requested_at&.iso8601)
              lab_order << create_node("SpecimenSource", request.description.bottle_type)
              lab_order << result_items_element
              lab_order << create_node("EnteredOn", request.requested_at.iso8601)
            end
          end

          def order_category_element
            create_node("OrderCategory") do |category|
              category << create_node("Code", request.description.code)
            end
          end

          def result_items_element
            create_node("ResultItems") do |items|
              request.observations.each do |observation|
                items << result_item_element_for(observation)
              end
            end
          end

          def result_item_element_for(observation)
            observation = Renalware::Pathology::ObservationPresenter.new(observation)
            observation = Renalware::UKRDC::PathologyObservationPresenter.new(observation)
            create_node("ResultItem") do |item|
              item << create_node("EnteredOn", observation.updated_at&.iso8601)
              item << create_node(
                "PrePost",
                observation.pre_post(patient_is_on_hd: patient.current_modality_hd?)
              )
              item << service_id_element_for(observation)
              rr_type_value_elements_for(observation, append_to: item)
              item << create_node("ObservationTime", observation.observed_at&.iso8601)
            end
          end

          def service_id_element_for(observation)
            create_node("ServiceId") do |elem|
              elem << create_node("CodingStandard", observation.coding_standard)
              elem << create_node("Code", observation.code)
              elem << create_node("Description", observation.description_name)
            end
          end

          # If the rr_type of the observation_description is interpretation (ie an interpretted
          # result like POS NEG the out
          def rr_type_value_elements_for(observation, append_to:)
            if observation.rr_type_interpretation?
              append_to << create_node("InterpretationCodes", observation.interpretation_code)
            else
              append_to << create_node("ResultValue", observation.result)
              append_to << create_node("ResultValueUnits", observation.measurement_unit_name)
            end
          end
        end
      end
    end
  end
end
# rubocop:enable Metrics/AbcSize