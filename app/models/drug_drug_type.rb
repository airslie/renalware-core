class DrugDrugType < ActiveRecord::Base

  belongs_to :drug
  belongs_to :drug_type

end
