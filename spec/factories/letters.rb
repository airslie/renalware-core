FactoryGirl.define do
  factory :letter do
    patient
    doctor
    state 'draft'
    letter_type 'clinic'
    letter_description
    recipient 'lall.sawr@nhs.net'
    body 'Dear Dr Sawr, I saw Mrs. Brown last Tuesay and I am pleased to report a marked improvement in her condition.'
    signature 'Dr. D.O. Good'
  end
end
