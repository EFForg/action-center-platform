@javascript
Feature: Enable affiliations on a petition
  As an EFF staff activist
  I want to enable affiliations on a petition
  So I can facilitate local organizing

  Background:
    Given I exist as an activist
    And I am logged in

  Scenario: Activists should be able to enable local affiliations
    When I go to "/admin/action_pages/new"
    And I click "Action Settings"
    And I check "Enable petition"
    And I check "Allow local affiliations"
    And I press "Save"
    And I click "Edit this page"
    And I click "Action Settings"
    Then the "Allow local affiliations" checkbox should be checked