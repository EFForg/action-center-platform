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
    And I stub SmartyStreets
    And I submit the petition
    Then I should see "Test User" within "#signatures"

  Scenario: A user can sign up for a partner newsletter
    Given a partner named "The Watchers Council" with the code "twc" exists
    And "The Watchers Council" is a partner on the action
    When I browse to the action page with a "The Watchers Council" newsletter signup
    And I fill in my name
    And I fill in my email
    And I fill in my zip code
    And I sign up for the newsletter of the partner with code "twc"
    And I submit the petition
    And there should be a persisted Subscription with:
        |first_name|Test|
        |last_name|User|
        |email|me@example.com|
        |partner_id|1|
