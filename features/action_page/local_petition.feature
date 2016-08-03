@javascript
Feature: Users petition an institution

  Background:
    Given a local organizing campaign
    And the local organizing campaign has multiple institutions

  Scenario: Users should be able to sign a local organizing petition on behalf of their school
    When I browse to the action page
    And I select "University of Wherever 1" from "Institution"
    And I select "Student" from "Affiliation type"
    And I click "Add another"
    And I select "University of Wherever 2" from "Institution" within ".nested-fields:nth-child(2)"
    And I select "Parent" from "Affiliation type" within ".nested-fields:nth-child(2)"
    And I fill in my name
    And I fill in my email
    And I submit the petition
    And I reload the page
    Then I should see "Student" within "#signatures"
    And I should see "University Of Wherever 1" within "#signatures"
    And I should see "Parent" within "#signatures"
    And I should see "University Of Wherever 2" within "#signatures"
    And I should not see "US" within "#signatures"

  Scenario: Users must input complete affiliation/relationship pairs
    When I browse to the action page
    And I select "Student" from "Affiliation type"
    And I click "Add another"
    And I select "University of Wherever 2" from "Institution" within ".nested-fields:nth-child(2)"
    And I click "Add another"
    Then "Institution" should be required within ".nested-fields:nth-child(1)"
    And "Affiliation type" should be required within ".nested-fields:nth-child(2)"
    And "Institution" should not be required within ".nested-fields:nth-child(3)"
    And "Affiliation type" should not be required within ".nested-fields:nth-child(3)"

  Scenario: Local organizing petitions should show all signatures
    Given the petition has 100 signatures with affiliations
    When I browse to the action page
    Then I should see "Next" within "#signatures"
    And I should not see "Download CSV"

  Scenario: Local organizing petitions filtered by institution should allow csv download
    Given the petition has 100 signatures with affiliations
    When I filter the action page by institution
    Then I should see "Next" within "#signatures"
    And I should see "Download CSV"
    When I click "Download CSV"
    Then I should receive a CSV file

  Scenario: Filtered local petitions should have the chosen institution preselected
    Given the petition has 100 signatures with affiliations
    When I filter the action page by institution
    Then the institution should be selected in the filter