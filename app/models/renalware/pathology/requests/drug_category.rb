# frozen_string_literal: true

require_dependency "renalware/pathology/requests"

module Renalware
  module Pathology
    module Requests
      class DrugCategory < ApplicationRecord
        has_and_belongs_to_many :drugs, join_table: "pathology_requests_drugs_drug_categories"

        validates :name, presence: true
      end
    end
  end
end
