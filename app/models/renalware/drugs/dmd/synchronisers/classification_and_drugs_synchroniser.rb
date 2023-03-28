# frozen_string_literal: true

module Renalware
  module Drugs::DMD
    module Synchronisers
      # Sync local data and many-to-many relationships based on
      # the already fetched & locally stored DM+D data.
      # Must've run {APISynchronisers::FullAPISynchroniser} prior to
      # fetch the DM+D data via external API calls.
      class ClassificationAndDrugsSynchroniser
        def call
          DrugSynchroniser.new.call

          VMPClassificationSynchroniser.new.call

          TradeFamilyClassificationSynchroniser.new.call
          DrugTypesClassificationSynchroniser.new.call

          # can be taken out after first synchronisation
          Drugs::Drug.where(code: nil).update_all(inactive: true)
        end
      end
    end
  end
end
