require_dependency "renalware/drugs"

module Renalware
  module Drugs
    class Classification < ApplicationRecord
      self.table_name = "drug_types_drugs" # a relic from migrating from habtm
      belongs_to :drug, touch: true
      belongs_to :drug_type, class_name: "Type", inverse_of: :classifications
    end
  end
end
