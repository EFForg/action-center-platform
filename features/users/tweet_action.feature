@javascript
Feature: Do a Tweet Action
  An interested member of the community should be able to tweet to
  Relevant congress people's twitter accounts

  Scenario: An activist creates a tweet petition and a supporter uses it
    Given A tweet petition targeting senate exists
    When I browse to the action page
    Then I see a button to lookup my reps
    When I fill in my tweet petition location info
      And I click the button to lookup my reps
