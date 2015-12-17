@javascript
Feature: Achieve Petition Goal
  An interested member of the community
  Should be able to sign a petition and reach the specified goal

  Scenario: A user signs a petition, achieving the action goal
    Given A petition exists that's one signature away from its goal
      And I exist as a user
      And I am logged in
    When I browse to the action page
    Then I see the petition hasn't met its goal
    When I sign the petition
    Then I am thanked for my participation
      And I see the petition has met its goal
    When The action is marked a victory
      And I browse to the action page
    Then I see a victory message
