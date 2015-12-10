Feature: Create Content
  In order to protect the internet (and such things)
  An activist
  Should be able to create content

  Background:
    Given I exist as an activist
      And I am not logged in

  Scenario: Activist logs in and sets up to create some content
    When I sign in with valid credentials
    And I visit the admin page
    When I click to create an action
    Then I see inputs for a new action_page
    When I fill in inputs to create a petition action
    Then I get the unpublished petition page
