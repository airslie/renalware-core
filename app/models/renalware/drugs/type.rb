require_dependency "renalware/drugs"

module Renalware
  module Drugs
    class Type < ApplicationRecord
      self.table_name = "drug_types"

      has_many :classifications, foreign_key: :drug_type_id, dependent: :destroy
      has_many :drugs, through: :classifications

      include OrderedSetScope

      def self.for(*codes)
        includes(:drugs)
          .ordered_set(:code, codes)
      end
    end
  end
end
