# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Patient.find_or_create_by!(:nhs_number => "1000124502") do |patient|
  patient.local_patient_id = "Z999999" 
  patient.surname = "RABBIT" 
  patient.forename = "R"
  patient.dob = "01/01/1947"
  patient.paediatric_patient_indicator = "1"
  patient.sex = "1"
  patient.ethnic_category = "A"
end
