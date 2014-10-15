# Feature: A user registers on to Renalware

#   Scenario: A user registers
#     Given a user who is not in the database
#       And they are on the register page
#     When they fill in the registration form 
#       And submit the form
#     Then they should see a acknowledgement page

#   Scenario: An admin activates a new user
#     Given there is an unactivated user
#     When the admin user logs in 
#     Then they will see a list of unactivated users
#       And they will select a new user
#       And they will update the new users profile
#     When they submit the form
#     Then the admin should be redirected to their dashboard
#       And the new user should receive a notification by email
#       And the user should no longer be on the unactivated list
