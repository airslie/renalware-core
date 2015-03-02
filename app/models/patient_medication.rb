require 'medication_route'

class PatientMedication < ActiveRecord::Base
  include Concerns::SoftDelete
  attr_accessor :drug_select

  acts_as_paranoid

  has_paper_trail :class_name => 'PatientMedicationVersion'

  belongs_to :medication, :polymorphic => true
  belongs_to :patients

  enum provider: %i(gp hospital home_delivery)

  # validates :medication_id, presence: true

  def self.medication_routes
    @medication_routes ||= YAML.load_file(Rails.root.join("data", "medication_routes.yml"))
  end

  def medication_route(id)
    self.class.medication_routes.find { |r| r.id == id }
  end
  
end
