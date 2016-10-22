@javascript
Feature: Change Email
  A user
  Should be able to change their email

  Background:
    Given I exist as a user

  Scenario: A user had an outstanding password reset token
    Given I am not logged in
    When I initiate a password reset request
    And I log in
    And I change my email address to "new@example.com"
    And I confirm that I changed my email address
    Then I should no longer have a hashed reset token in my user record
    And I should be on "/"

  Scenario: Users are not notified when email uniqueness validation fails
    Given a user with the email "existing@example.com"
    When I log in
    And I change my email address to "existing@example.com"
    Then I should not see "Error"
    And I should see "You updated your account successfully, but we need to verify your new email address. Please check your email and click on the confirm link to finalize confirming your new email address."
    And I should be on "/"

