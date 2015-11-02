require_dependency 'renalware/drugs'

module Renalware
  module Drugs
    class Drug < ActiveRecord::Base
      acts_as_paranoid

      has_and_belongs_to_many :drug_types, class_name: "Type",
        association_foreign_key: :drug_type_id

      validates :name, presence: true

      def self.for(code)
        joins(:drug_types).where(drug_types: {code: code.to_s})
      end

      def display_type
        "Standard Drug"
      end

      def to_s
        name
      end
    end
  end
end
