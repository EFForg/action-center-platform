@javascript
Feature: Do a Call Action
  An interested member of the community should be able to call a custom campaign target

  Background:
    I am not logged in

  Scenario: An activist creates a call petition for a custom target and a supporter uses it
    Given a call petition targeting a custom number exists

    When I browse to the action page
    Then I see form fields for phone number but not zip code

    When I fill in my phone number and click call
    Then I see instructions for what to say