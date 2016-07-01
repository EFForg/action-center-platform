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
    And I complete the petition
    And I reload the page
    Then I should see "Student" within "#signatures"
    And I should see "University Of Wherever 1" within "#signatures"
    And I should see "Parent" within "#signatures"
    And I should see "University Of Wherever 2" within "#signatures"
