@javascript
Feature: Users can sign petitions

  Background:
    Given A petition exists thats one signature away from its goal

  Scenario: Petitions should not show all signatures
    When I browse to the action page
    Then I should not see "Next" within "#signatures"
    And I should not see "Download CSV"

  Scenario: New signatures should immediately appear below the petition
    When I browse to the action page
    And I fill in my name
    And I fill in my email
    And I fill in my zip code
    And I submit the petition
    And I save the page
    Then I should see "Test User" within "#signatures"
