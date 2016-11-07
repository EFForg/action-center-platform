@javascript
Feature: Do a Call Action
  An interested member of the community should be able to call
  Relevant congress members' offices

  Background:
    I am not logged in

  Scenario: An activist creates a call petition and a supporter uses it
    Given a call petition targeting senate exists

    When I browse to the action page
    Then I see form fields for phone number, address, and zip code

    When I fill in my phone number, address, and zip code and click call
    Then I see instructions for what to say
