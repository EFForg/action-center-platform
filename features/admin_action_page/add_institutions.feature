@javascript
Feature: Add institutions to an action
  As an EFF staff activist
  I want to add institutions to an action
  So I can run local organizing cmapaigns

  Background:
    Given I exist as an activist
    And I am logged in

  Scenario: Activists should be able to upload a csv of institutions
    When I go to "/admin/action_pages/new"
    And I click "Action Settings"
    And I check "Enable petition"
    And I check "Allow local affiliations"
    And I press "Save"
    And I click "Edit this page"
    Then the "Allow local affiliations" checkbox should be checked