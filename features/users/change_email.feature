@javascript
Feature: Change Email
  A user
  Should be able to change their email

  Scenario: A user had an outstanding password reset token
    Given I exist as a user
      And I am not logged in
    When I initiate a password reset request
    And I log in
    And I change my email address
    Then I should no longer have a hashed reset token in my user record
