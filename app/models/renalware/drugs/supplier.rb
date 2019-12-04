# frozen_string_literal: true

require_dependency "renalware/drugs"

module Renalware
  module Drugs
    class Supplier < ApplicationRecord
      self.table_name = "drug_suppliers"
      validates :name, presence: true
    end
  end
end
