@javascript
Feature: Users can sign up for mailings on email action pages

  Background: Email actions should include an opt-in for mailings
    Given an email campaign exists
    When I browse to the action page
    Then I should see an option to sign up for mailings

  Scenario: Not opting in should not sign you up for mailings
    When I click open using gmail
    Then I should not have signed up for mailings

  Scenario: Opting in should sign you up for mailings
    When I enter the email "test@example.com" and opt for mailings
    And I click open using gmail
    And a new window opens
    Then "test@example.com" should be signed up for mailings
