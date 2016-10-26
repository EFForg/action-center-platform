@javascript
Feature: Enable collaborator status
  An admin should be able to find a user and change their .collaborator? status

  Background:
    Given I exist as an activist
    And a user with the email "test@example.com"
    And I am logged in

  Scenario:
    When I am on "/admin/users"
    And I fill in "query" with "test"
    And I press "Add as collaborator"
    Then the user "test@example.com" should be a collaborator

    When I press "Remove as collaborator"
    Then the user "test@example.com" should not be a collaborator
