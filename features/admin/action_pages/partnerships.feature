Feature: Manage partners on an action

  Background:
    Given I exist as an activist
    And a partner named "Fight for the Future" with the code "fftf" exists
    And a partner named "Freedom of the Press Foundation" with the code "fpf" exists
    And I am logged in

  Scenario: Activists should be able to add multiple partners to an action
    When I go to "/admin/action_pages/new"
    And I click "Content"
    And I fill in "action_page_title" with "Save the Internet"
    And I select "Fight for the Future" from "Partner newsletter signups"
    And I select "Freedom of the Press Foundation" from "Partner newsletter signups"
    And I click "Action Settings"
    And I check "Enable petition"
    And I press "Save"
    And I click "Edit this page"
    Then "Fight for the Future" should be selected from "Partner newsletter signups"
    And "Freedom of the Press Foundation" should be selected from "Partner newsletter signups"

