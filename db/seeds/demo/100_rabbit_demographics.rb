module Renalware
  log '--------------------Adding Demographics for Roger RABBIT--------------------'
  user = User.find_by(username: "bartsdoc")
  rabbit = Patient.find_by(family_name: 'RABBIT', given_name: 'Roger')

  rabbit.title = "Mr"
  rabbit.suffix = "OBE"
  rabbit.marital_status = "divorced"
  rabbit.telephone1 = "0201 555 1212"
  rabbit.email = "rogerrabbit@rmail.co.uk"
  rabbit.religion_id = 1
  rabbit.language_id = 1
  rabbit.by = user
  rabbit.document = {referral:
    {referral_date: 1.week.ago,
      referral_type: "Urgent",
      referral_notes: "NB family friend of referrer",
      referring_physician_name: "Dr Jack L N Hyde"},
    admin_notes: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
tempor incididunt ut labore et dolore magna aliqua."
  }
  rabbit.save!
end
