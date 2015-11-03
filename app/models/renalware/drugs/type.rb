require_dependency 'renalware/drugs'

module Renalware
  module Drugs
    class Type < ActiveRecord::Base
      self.table_name = "drug_types"

      has_and_belongs_to_many :drugs, foreign_key: :drug_type_id

      include OrderedSetScope

      def self.for(*codes)
        includes(:drugs)
          .ordered_set(:code, codes)
      end
    end
  end
end
