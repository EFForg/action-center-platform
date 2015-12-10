@javascript
Feature: Sign out
  In order to protect the Internet (and such things)
  A community member
  Should be able to sign out

  Scenario: Member logs in, views email address, then logs out, then
  hits the back button, but secrets are not revealed.
    Given I exist as a user
      And I am logged in
    When I visit the dashboard
    And I sign out
    And I click the back button
    Then I don't see my information
