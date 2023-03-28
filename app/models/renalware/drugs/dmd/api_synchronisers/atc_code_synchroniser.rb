# frozen_string_literal: true

module Renalware
  module Drugs::DMD
    module APISynchronisers
      class AtcCodeSynchroniser
        def initialize(atc_vmp_mapping_reposotory: Repositories::AtcVMPMappingRepository.new)
          @atc_vmp_mapping_reposotory = atc_vmp_mapping_reposotory
        end
        attr_reader :atc_vmp_mapping_reposotory

        def call
          now = Time.current

          atc_vmp_mapping_reposotory.call.each do |mapping|
            VirtualMedicalProduct.where(code: mapping.vmp_code)
              .update_all(atc_code: mapping.atc_code, updated_at: now)
          end
        end
      end
    end
  end
end
