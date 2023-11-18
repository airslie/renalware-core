# frozen_string_literal: true

module Renalware
  module Drugs::DMD
    module APISynchronisers
      class VirtualMedicalProductSynchroniser
        COUNT = 100

        pattr_initialize [repository: Repositories::VirtualMedicalProductRepository.new]

        def call
          offset = 0

          loop do
            entries = repository.call(offset: offset, count: COUNT)

            Rails.logger.info(
              "[VirtualMedicalProductSynchroniser] offset: #{offset}; records: #{entries.size}"
            )

            break if entries.empty?

            now = Time.current
            upserts = entries.map do |entry|
              entry.to_h.update(updated_at: now)
            end

            VirtualMedicalProduct.upsert_all(upserts, unique_by: :code)

            offset += COUNT
          end
        end
      end
    end
  end
end
