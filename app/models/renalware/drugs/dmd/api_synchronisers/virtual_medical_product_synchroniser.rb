# frozen_string_literal: true

module Renalware
  module Drugs::DMD
    module APISynchronisers
      class VirtualMedicalProductSynchroniser
        COUNT = 100

        def initialize(virtual_medical_product_repository: Repositories::VirtualMedicalProductRepository.new) # rubocop:disable Layout/LineLength
          @virtual_medical_product_repository = virtual_medical_product_repository
        end
        attr_reader :virtual_medical_product_repository

        def call # rubocop:disable Metrics/MethodLength
          offset = 0

          loop do
            entries = virtual_medical_product_repository.call(offset: offset, count: COUNT)

            Rails.logger.info "[VirtualMedicalProductSynchroniser] offset: #{offset}; records: #{entries.size}" # rubocop:disable Layout/LineLength

            break if entries.empty?

            now = Time.current
            upserts = entries.map do |entry|
              {
                code: entry.code,
                name: entry.name,
                form_code: entry.form_code,
                route_code: entry.route_code,
                unit_of_measure_code: entry.unit_of_measure_code,
                basis_of_strength: entry.basis_of_strength,
                strength_numerator_value: entry.strength_numerator_value,
                virtual_therapeutic_moiety_code: entry.virtual_therapeutic_moiety_code,
                updated_at: now
              }
            end

            VirtualMedicalProduct.upsert_all(upserts, unique_by: :code)

            offset += COUNT
          end
        end
      end
    end
  end
end
