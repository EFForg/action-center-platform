@javascript
Feature: Add institutions to an action
  As an EFF staff activist
  I want to add institutions to an action
  So I can run local organizing campaigns

  Background:
    Given I exist as an activist
    And I am logged in
    And a petition action exists
    And local affiliations are allowed

  # Scenario: Activists upload a csv of institutions
  #   When I edit the action page
  #   And I click "Action Settings"
  #   And I click "Add or edit local institutions"
  #   And I switch to the new window
  #   And I attach the file "./features/upload_files/schools.csv" to "file"
  #   Then I should see "University of California, Berkeley"
  #   And I should see "University of California, Davis"
  #   And I should see "University of California, Santa Cruz"

  Scenario: Activists access affiliation types from saved action
    When I edit the action page
    And I click "Action Settings"
    And I click "Add or edit relationships"
    Then I should see "Editing relationships for Sample Action Page" within the new window
