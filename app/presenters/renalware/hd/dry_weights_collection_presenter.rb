module Renalware
  module HD
    class DryWeightsCollectionPresenter
      def initialize(patient)
        @patient = patient
      end

      def find_all
        present(collection)
      end

      def latest
        present(collection.limit(10))
      end

      private

      def present(collection)
        collection.map { |dry_weight| DryWeightPresenter.new(dry_weight) }
      end

      def collection
        DryWeight.for_patient(@patient).ordered
      end
    end
  end
end
