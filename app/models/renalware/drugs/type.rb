require_dependency 'renalware/drugs'

module Renalware
  module Drugs
    class Type < ActiveRecord::Base
      self.table_name = "drug_types"

      has_and_belongs_to_many :drugs
    end
  end
end
