module Renalware
  class DrugDrugType < ActiveRecord::Base
    belongs_to :drug
    belongs_to :drug_type

    validates :drug_type, uniqueness: { scope: :drug }
  end
end