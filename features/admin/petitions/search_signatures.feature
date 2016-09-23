@javascript
Feature: Search petition signatures
  An admin should be able to search petition signatures

  Background:
    Given I exist as an activist
    And I am logged in
    And a petition exists with many signatures

  Scenario:
    When I visit the signatures list
    When I search for an email in the petitions list
    Then the matching signatures should be in the results

  Scenario:
    When I visit the signatures list
    When I search for an email not in the petitions list
    Then there should be no matching signatures
