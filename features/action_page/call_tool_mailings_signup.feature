@javascript
Feature: Users can sign up for mailings on call action pages

  Background: Call actions should include an opt-in for mailings
    Given a call campaign exists
    When I browse to the action page
    Then I should see an option to sign up for mailings

  Scenario: Not opting in should not sign you up for mailings
    When I fill in my phone number, address, and zip code and click call
    Then I should not have signed up for mailings

  Scenario: Opting in should sign you up for mailings
    When I enter the email "test@example.com" and opt for mailings
    And I fill in my phone number, address, and zip code and click call
    Then "test@example.com" should be signed up for mailings
