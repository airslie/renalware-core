class Clinic < ActiveRecord::Base
  belongs_to :patient

  validates_presence_of :date
  validates_presence_of :height
  validates_presence_of :weight
  validates_presence_of :systolic_bp
  validates_presence_of :diastolic_bp

  def bmi
    ((weight / height) / height).round(2)
  end
end
