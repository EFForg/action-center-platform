@javascript
Feature: Enable affiliations on a petition
  As an EFF staff activist
  I want to enable affiliations on a petition
  So I can facilitate local organizing

  Background:
    Given I exist as an activist
    And I am logged in

  Scenario: Activists should be able to enable local affiliations
    When I edit an action page
    And I click "Add or edit local institutions"
    And I press "Upload a CSV"
    And I upload the file "schools.csv"
    Then I should see "University of California, Berkeley"
    And I should see "University of California, Davis"
    And I should see "University of California, Santa Cruz"