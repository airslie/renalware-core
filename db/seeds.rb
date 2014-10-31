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

PatientEventType.find_or_create_by(name: "Other")
PatientEventType.find_or_create_by(name: "Access clinic")
PatientEventType.find_or_create_by(name: "Anaemia clinic")
PatientEventType.find_or_create_by(name: "CAPD Nurses clinic")
PatientEventType.find_or_create_by(name: "CAPD clinic")
PatientEventType.find_or_create_by(name: "Counsellor Meeting")
PatientEventType.find_or_create_by(name: "Dietitians clinic")
PatientEventType.find_or_create_by(name: "General Nephrology Clinic")
PatientEventType.find_or_create_by(name: "Haemodialysis clinic")
PatientEventType.find_or_create_by(name: "Home Haemodialysis clinic")
PatientEventType.find_or_create_by(name: "Iron clinic")
PatientEventType.find_or_create_by(name: "Low Clearance clinic")
PatientEventType.find_or_create_by(name: "Meeting with family")
PatientEventType.find_or_create_by(name: "MDM--Liver Renal Virology")
PatientEventType.find_or_create_by(name: "MDM--Renal Biopsy")
PatientEventType.find_or_create_by(name: "MDM--Radiology")
PatientEventType.find_or_create_by(name: "MDM--Renal Sickle")
PatientEventType.find_or_create_by(name: "Physiotherapist")
PatientEventType.find_or_create_by(name: "Research visit")
PatientEventType.find_or_create_by(name: "Result Review")
PatientEventType.find_or_create_by(name: "Social Worker")
PatientEventType.find_or_create_by(name: "Telephone call")
PatientEventType.find_or_create_by(name: "Email")
PatientEventType.find_or_create_by(name: "Transplant clinic")
PatientEventType.find_or_create_by(name: "Walk-in clinic")
PatientEventType.find_or_create_by(name: "Ward round")
PatientEventType.find_or_create_by(name: "Dartford Outreach Clinic")
PatientEventType.find_or_create_by(name: "Woolwich Outreach Clinic")
PatientEventType.find_or_create_by(name: "Plasma Exchange")
PatientEventType.find_or_create_by(name: "Tx Coordination")


