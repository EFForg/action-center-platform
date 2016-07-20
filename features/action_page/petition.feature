@javascript
Feature: Users can sign petitions

  Background:
    Given A petition exists thats one signature away from its goal

  Scenario: Petitions should not show all signatures
    When I browse to the action page
    Then I should not see "All Signatures"
    And I should not see "Download CSV"
