# event is also known as encounter
# Not implemented in PHP, done at DB level?

Feature: An admin manages event types

Background:
  Given that I'm logged in
    And there are existing event types in the database

Scenario: Admin adds a new event type
  Given they choose to add a new event type
    And they complete the new event form
  Then they should see the new event type added to the event types index

Scenario: Admin edits an existing event type
  Given they visit the event types index
  When they choose to edit an event type
    And complete the event type form
  Then they should see the updated event type in the event types index

Scenario: Admin soft deletes an existing event type
  Given they visit the event types index
  When they choose to soft delete a event type
  Then they should see this event type removed from the event types index