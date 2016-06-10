@javascript
Feature: Enable affiliations on a petition
  As an EFF staff activist
  I want to enable affiliations on a petition
  So I can facilitate local organizing

  Background:
    Given I exist as an activist
    And I am logged in
    And an institution set with the name "U.S. Colleges and Universities"

  Scenario: Activists should be to enable and configure local affiliations
    When I go to "/admin/action_pages/new"
    And I click "Action Settings"
    And I check "Enable petition"
    And I check "Allow local affiliations"
    And I select "U.S. Colleges and Universities" from "Allowed institutions"
    And I press "Save"
    And I click "Edit this page"
    Then the "Allow local affiliations" checkbox should be checked
    And "U.S. Colleges and Univerities" should be selected from "Allowed institutions"