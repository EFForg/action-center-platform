Feature: Manage partners on an action

  Background:
    Given I exist as an activist
    And a partner named "Fight for the Future" exists
    And a partner named "Freedom of the Press Foundation" exists
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
    Then I should be on "/action/save-the-internet"
    Then I should see "Fight for the Future"
    And I should see "Freedom of the Press Foundation"

