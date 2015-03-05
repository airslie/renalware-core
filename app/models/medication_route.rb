class MedicationRoute < ActiveRecord::Base
  belongs_to :administration
  belongs_to :administerable, polymorphic: true
end