require 'rails_helper'

RSpec.describe Patient, :type => :model do
  it { should have_many :problems } 
  it { should accept_nested_attributes_for(:problems) }
  it { should have_one :patient_modality }
  it { should have_one(:modality_code).through(:patient_modality)}
  it { should accept_nested_attributes_for(:patient_modality)}   
end
