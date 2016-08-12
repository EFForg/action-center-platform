@javascript
Feature: Achieve Petition Goal
  An interested member of the community
  Should be able to sign a petition and reach the specified goal

  Scenario: A user signs a petition, achieving the action goal
    Given A petition exists thats one signature away from its goal
      And I exist as a user
      And I am logged in

    When I sign a petition thats one signature away from victory
    Then my signature is acknowledged

    When the action is marked a victory
    Then I see a victory message
