class PatientMedication < ActiveRecord::Base
  include Concerns::SoftDelete
  attr_accessor :drug_select

  has_paper_trail :class_name => 'MedicationVersion'

  belongs_to :medication, :polymorphic => true
  belongs_to :patients

  enum route: %i(po iv sc im other)
  enum provider: %i(gp hospital home_delivery)

  # validates :medication_id, presence: true

  def history
    problem = self
    history = [problem]
    while (problem = problem.previous_version) != nil
      history << problem
    end
    history.shift
    history
  end
  
end
