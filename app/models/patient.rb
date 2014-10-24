class Patient < ActiveRecord::Base

  belongs_to :current_address, :class_name => "Address", :foreign_key => :current_address_id
  belongs_to :address_at_diagnosis, :class_name => "Address", :foreign_key => :address_at_diagnosis_id

  accepts_nested_attributes_for :current_address
  accepts_nested_attributes_for :address_at_diagnosis

  has_many :encounter_events

end
