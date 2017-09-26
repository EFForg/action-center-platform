@javascript
Feature: Users can sign up for mailings on email action pages

  Background: Email actions should include an opt-in for mailings
    Given an email campaign exists
    And a partner named "The Watchers Council" with the code "twc" exists
    And "The Watchers Council" is a partner on the action
    And I browse to the action page with a "The Watchers Council" newsletter signup

  Scenario: Opting in should sign you up for mailings
    When I fill in "subscription_email" with "bsummers@ucsunnydale.edu"
    And I sign up for the newsletter of the partner with code "twc"
    And I click open using gmail
    Then there should be a persisted Subscription with:
        |email|bsummers@ucsunnydale.edu|
        |partner_id|1|
