module Renalware
  class DrugType < ActiveRecord::Base

    has_many :drug_drug_types
    has_many :drugs, through: :drug_drug_types

  end
end