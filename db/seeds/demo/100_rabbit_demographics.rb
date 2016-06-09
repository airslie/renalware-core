module Renalware
  log '--------------------Adding Demographics for Roger RABBIT--------------------'
  system_user = SystemUser.find
  rabbit = Patient.find_by(family_name: 'RABBIT', given_name: 'Roger')

  rabbit.title = "Mr"
  rabbit.suffix = "OBE"
  rabbit.marital_status = "divorced"
  rabbit.telephone1 = "0201 555 1212"
  rabbit.email = "rogerrabbit@rmail.co.uk"
  rabbit.religion_id = 1
  rabbit.language_id = 1
  rabbit.by = system_user
  rabbit.save!
end
