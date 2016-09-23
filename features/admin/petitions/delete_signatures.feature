@javascript
Feature: Delete petition signatures
  An admin should be able to delete petition signatures

  Background:
    Given I exist as an activist
    And I am logged in
    And a petition exists with many signatures

  Scenario:
    When I visit the signatures list
    When I select some signatures
    When I click destroy
    Then the selected signatures are destroyed

  Scenario:
    When I visit the signatures list
    When I click the select all checkbox
    Then all signatures are selected